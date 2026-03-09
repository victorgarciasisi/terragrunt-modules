## Users ##
resource "aws_eks_access_entry" "users" {
  for_each         = toset(var.users)
  cluster_name     = module.eks.cluster_name
  principal_arn    = "arn:aws:iam::${var.account_id}:user/${each.value}"
  type             = "STANDARD"

  depends_on = [module.eks]
}

resource "aws_eks_access_policy_association" "admin_policy_users" {
  for_each         = toset(var.users)
  cluster_name     = module.eks.cluster_name
  principal_arn    = "arn:aws:iam::${var.account_id}:user/${each.value}"
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [module.eks]
}

