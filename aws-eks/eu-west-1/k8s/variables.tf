variable cluster_name {
  type = string
}

variable environment {
  type = string
}

variable account_name {
  type = string
}

variable account_id {
  type = string
}

variable vpc_id {
	type = string
}

variable private_subnets {
  type = list(string)
}

variable public_subnets {
  type = list(string)
}

variable cluster_endpoint_public_access {
  type    = bool
  default = true
}

variable cluster_endpoint_private_access {
  type    = bool
  default = true
}

variable aws_region {
  type    = string
  default = "eu-south-2"
}

variable "cluster_endpoint" {
  type = string
}

variable "cluster_certificate_authority_data" {
  type = string
}

variable "node_group_autoscaling_names" {
  type = list(string)
}

