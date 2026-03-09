resource "aws_iam_user" "users" {
  for_each = toset(var.usernames)  

  name = each.key  
}

resource "aws_iam_access_key" "user_access_keys" {
  for_each = toset(var.usernames)

  user = aws_iam_user.users[each.key].name
}

# Política que permite DescribeCluster al EKS
resource "aws_iam_policy" "eks_describe_cluster" {
  name = "eks-describe-cluster"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowDescribeSpecificCluster"
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster"
        ]
        Resource = "arn:aws:eks:${var.region}:${var.account_id}:cluster/${var.cluster_name}"
      }
    ]
  })
}

# Adjuntar la política a los usuarios indicados en var.users
resource "aws_iam_user_policy_attachment" "eks_describe_to_users" {
  for_each   = toset(var.usernames)
  user       = each.value
  policy_arn = aws_iam_policy.eks_describe_cluster.arn
}


