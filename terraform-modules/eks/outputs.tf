
output "eks_oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.oidc.arn
  sensitive   = true
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.eks_cluster.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  sensitive   = true
}
