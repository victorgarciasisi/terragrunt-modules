variable "environment" {
  type = string
}

variable "ecr_users" {
  description = "Usuarios IAM a los que se les dará acceso completo a ECR"
  type        = list(string)
  default     = []
}
