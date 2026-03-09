include "root" {
	path = find_in_parent_folders()
}

dependency "vpc" {
	config_path = "../vpc"
}

dependency "iam" {
	config_path = "../iam"
}

inputs = merge(local.config, {
	vpc_id = dependency.vpc.outputs.vpc_id	
	private_subnets = dependency.vpc.outputs.private_subnets
	public_subnets = dependency.vpc.outputs.public_subnets
})


locals {
	config = yamldecode(file(find_in_parent_folders("config.yaml")))
}