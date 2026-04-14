resource "aws_iam_user_policy_attachment" "ecr_managed_full" {
  for_each   = toset(var.ecr_users)   # nombres IAM (no ARNs)
  user       = each.value
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}
