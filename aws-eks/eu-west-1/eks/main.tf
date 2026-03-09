module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  ## ACTUALIZAR CLUSTER CON FRECUENCIA PARA AHORRAR
  cluster_version = "1.35"

  vpc_id                         = var.vpc_id
  subnet_ids                     = var.private_subnets
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access

  eks_managed_node_group_defaults = {
    ## INSTANCIA DE LOS NODOS AMAZON LINUX 2023
    ami_type = "AL2023_x86_64_STANDARD"
  }

  ## Node groups ##
  eks_managed_node_groups = {
    one = {
      name           = "node-group-1"
      instance_types = ["t3a.small"]
      min_size       = 1
      max_size       = 1
      disk_size      = 30
    }

    two = {
      name           = "node-group-2"
      instance_types = ["t3a.small"]
      min_size       = 1
      max_size       = 4
      disk_size      = 30
    }

  }
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

## Security groups ##

resource "aws_security_group_rule" "allow_http_within_sg" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"  
  security_group_id = module.eks.node_security_group_id
  source_security_group_id = module.eks.node_security_group_id
  depends_on = [ module.eks ]
}

resource "aws_security_group_rule" "allow_https_within_sg" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"  
  security_group_id = module.eks.node_security_group_id
  source_security_group_id = module.eks.node_security_group_id
  depends_on = [ module.eks ]
}
