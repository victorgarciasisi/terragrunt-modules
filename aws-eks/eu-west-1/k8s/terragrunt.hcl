include "root" {
	path = find_in_parent_folders()
}

dependency "vpc" {
	config_path = "../vpc"	
}

dependency "eks" {
	config_path = "../eks"
}

inputs = merge(local.config, {
	vpc_id = dependency.vpc.outputs.vpc_id	
	private_subnets = dependency.vpc.outputs.private_subnets
	public_subnets = dependency.vpc.outputs.public_subnets
	cluster_name                  = dependency.eks.outputs.cluster_name
    cluster_endpoint              = dependency.eks.outputs.cluster_endpoint
    cluster_certificate_authority_data = dependency.eks.outputs.cluster_certificate_authority_data
	eks_managed_node_groups            = dependency.eks.outputs.eks_managed_node_groups
	fargate_profiles                   = dependency.eks.outputs.fargate_profiles
	node_group_autoscaling_names = dependency.eks.outputs.eks_managed_node_groups_autoscaling_group_names
})


locals {
	config = yamldecode(file(find_in_parent_folders("config.yaml")))
}