
output "role_arn" {
  value = aws_iam_role.karpenter.arn
}

output "role_name" {
  value = aws_iam_role.karpenter.name
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.karpenter_node.name
}

output "node_role_name" {
  value = aws_iam_role.karpenter_node.name
}