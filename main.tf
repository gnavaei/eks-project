module "vpc" {
  source = "./modules/vpc"
}

module "eks" {
  source = "./modules/eks"

  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
}

module "ebs_csi_irsa" {
  source = "./modules/irsa"

  iam_role_name        = "AmazonEKS_EBS_CSI_DriverRole"
  namespace            = "kube-system"
  service_account_name = "ebs-csi-controller-sa"

  oidc_provider_arn = "arn:aws:iam::397348547008:oidc-provider/oidc.eks.eu-west-2.amazonaws.com/id/C74AB98BF5A2EF2764D44B57924376C1"

  oidc_provider_url = "oidc.eks.eu-west-2.amazonaws.com/id/C74AB98BF5A2EF2764D44B57924376C1"
}

resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {
  role       = module.ebs_csi_irsa.role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "external_secrets_irsa" {
  source = "./modules/irsa"

  iam_role_name        = "external-secrets-role"
  namespace            = "external-secrets"
  service_account_name = "external-secrets"

  oidc_provider_arn = "arn:aws:iam::397348547008:oidc-provider/oidc.eks.eu-west-2.amazonaws.com/id/C74AB98BF5A2EF2764D44B57924376C1"

  oidc_provider_url = "oidc.eks.eu-west-2.amazonaws.com/id/C74AB98BF5A2EF2764D44B57924376C1"
}

resource "aws_iam_policy" "external_secrets" {
  name = "ExternalSecretsPolicy"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ]

      Resource = "arn:aws:secretsmanager:eu-west-2:397348547008:secret:postgres-creds-YeVTtr"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "external_secrets" {
  role       = module.external_secrets_irsa.role_name
  policy_arn = aws_iam_policy.external_secrets.arn
}
