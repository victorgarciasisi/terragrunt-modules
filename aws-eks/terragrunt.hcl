locals {
  # Automatically load account-level variables
	config_path = "${get_parent_terragrunt_dir()}/config.yaml"
	config = yamldecode(file(local.config_path))
	environment = local.config.account_name
	dinamo_table = local.config.dinamo_table
}
generate "provider" {
	path = "provider.tf"
	if_exists = "overwrite_terragrunt"
	contents = <<EOF
		provider "aws" {
		region = "${local.config.region}"

		default_tags {
			tags = {
				account = "${local.config.account_name}"
				terraform = "true"
				module = "${local.config.account_name}/${path_relative_to_include()}"
			}

		}
		}
		EOF
}

remote_state {
	backend = "s3"
	config = {
		encrypt = true
		bucket = "${local.config.account_name}-tf-states"
		key = "infrastructure/${local.config.account_name}/${path_relative_to_include()}/terraform.tfstate"
		region = local.config.region
		skip_region_validation = true
		dynamodb_table = local.dinamo_table
	}
	generate = {
		path = "backend.tf"
		if_exists = "overwrite_terragrunt"
	}
}

generate "versions" {
	path = "versions.tf"
	if_exists = "overwrite_terragrunt"
	contents = <<EOF
	terraform {
		required_version = "~> 1.13.3"
		 required_providers {
			aws = {
			source  = "hashicorp/aws"
			version = ">= 5.83.0"
			}
			kubernetes = {
			source  = "hashicorp/kubernetes"
			version = ">= 2.10"
			}
  }
	}
EOF
}

# iam_role = "arn:aws:iam::${local.config.account_id}:role/OrganizationAccountAccessRole"
