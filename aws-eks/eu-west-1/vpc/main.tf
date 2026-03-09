module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = var.environment
  cidr = var.cidr

  azs                  = var.azs  
  enable_dns_hostnames = true
  enable_nat_gateway = true
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  single_nat_gateway = true
  one_nat_gateway_per_az = false

   public_subnet_tags = {
    "Tier" = "public"
  }

  private_subnet_tags = {
    "Tier" = "private"
  }

  manage_default_network_acl = false

}

