## Roles and Policies  ###

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cluster_role" {
  name               = "eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster_role.name
}

## autoscaler policy ##
resource "aws_iam_policy" "cluster_autoscaler" {
  name        = "eks-cluster-autoscaler-policy"
  description = "Política que permite a Cluster Autoscaler gestionar grupos de Auto Scaling"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions",
          "eks:DescribeNodegroup"
        ],
        Resource = "*"
      }
    ]
  })
}

# Adjunta la política del autoscaler a TODOS los node groups gestionados por el módulo EKS
resource "aws_iam_role_policy_attachment" "cluster_autoscaler_attachment" {
  for_each   = module.eks.eks_managed_node_groups
  role       = each.value.iam_role_name
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
}

## Cloudwatch Role ##
resource "aws_iam_role" "cloudwatch_role" {
  name               = "CloudWatchAccessRole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "eks.amazonaws.com" // Puedes cambiar esto según la necesidad
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

## Cloudwatch Policy ###
resource "aws_iam_policy" "cloudwatch_policy" {
  name   = "CloudWatchAccessPolicy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "cloudwatch:*"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_attachment" {
  role       = aws_iam_role.cloudwatch_role.name
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}

