output "ecr_repository_url" {
  description = "URL of the created ECR Repository"
  value       = aws_ecr_repository.app_repo.repository_url
}

output "eks_cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}
