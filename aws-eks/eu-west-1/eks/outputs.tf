output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint  
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "eks_managed_node_groups_autoscaling_group_names" {
  description = "Nombres de los grupos de autoscaling de los nodos gestionados por EKS"
  value       = module.eks.eks_managed_node_groups_autoscaling_group_names
}

output "eks_managed_node_groups" {
  value = module.eks.eks_managed_node_groups
}

output "fargate_profiles" {
  value = module.eks.fargate_profiles
}

output "node2_group_name" {
  value = values(module.eks.eks_managed_node_groups)[1].iam_role_name
}
