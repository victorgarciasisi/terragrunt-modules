resource "aws_ecr_repository" "ecr-app" {
  name = "${var.environment}/ecr-app"
}
