output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.cluster.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.cluster.cluster_security_group_id
}

output "region" {
  description = "AWS region."
  value       = var.region
}

output "cluster_name" {
  value = module.cluster.cluster_id
}

output "load_balancer_controller_irsa_role_arn" {
  value = var.load_balancer_controller_irsa_role_arn == "" ? module.load_balancer_controller_irsa_role.iam_role_arn : var.load_balancer_controller_irsa_role_arn
}

output "ssm_instance_profile" {
  value = var.create_ssm_profile ? aws_iam_instance_profile.ec2_ssm_core[0].name : var.iam_instance_profile
}
