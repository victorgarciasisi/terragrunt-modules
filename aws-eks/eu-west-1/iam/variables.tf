variable "usernames" {
  description = "Lista de nombres de usuario de IAM"
  type        = list(string)
}

variable "account_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}