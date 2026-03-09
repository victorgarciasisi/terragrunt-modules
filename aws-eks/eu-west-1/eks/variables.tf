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

variable root_account_id {
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
}

variable "users" {
  description = "Lista de usuarios de IAM"
  type        = list(string)
}
