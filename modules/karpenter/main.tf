resource "aws_iam_role" "karpenter" {
  name = "karpenter-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Federated = var.oidc_provider_arn
      }

      Action = "sts:AssumeRoleWithWebIdentity"

      Condition = {
        StringEquals = {
          "${var.oidc_provider_url}:sub" = "system:serviceaccount:karpenter:karpenter"
        }
      }
    }]
  })
}

resource "aws_iam_policy" "karpenter" {
  name = "KarpenterControllerPolicy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeImages",
          "ec2:DescribeSpotPriceHistory",
          "ssm:GetParameter",
          "pricing:GetProducts"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "ec2:RunInstances",
          "ec2:TerminateInstances"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "eks:DescribeCluster"
        ]

        Resource = "arn:aws:eks:eu-west-2:397348547008:cluster/eks-project"
      },

      {
        Effect = "Allow"

        Action = [
          "ec2:CreateLaunchTemplate",
          "ec2:CreateTags",
          "ec2:CreateFleet"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "iam:GetInstanceProfile",
          "iam:ListInstanceProfiles",
          "iam:GetRole",
          "iam:PassRole"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "karpenter_node" {
  name = "karpenter-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_instance_profile" "karpenter_node" {
  name = "karpenter-node-instance-profile"
  role = aws_iam_role.karpenter_node.name
}

resource "aws_iam_role_policy_attachment" "karpenter" {
  role       = aws_iam_role.karpenter.name
  policy_arn = aws_iam_policy.karpenter.arn
}

resource "aws_iam_role_policy_attachment" "worker_node" {
  role       = aws_iam_role.karpenter_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni" {
  role       = aws_iam_role.karpenter_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.karpenter_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}