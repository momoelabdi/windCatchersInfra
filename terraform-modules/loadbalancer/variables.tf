variable "cluster_name" {
  type        = string
  description = "AWS EKS Cluster Name"
}
variable "vpc_id" {
  type        = string
  description = "EKS VPC ID"
}

variable "environment" {
  type        = string
  description = "The name of the environment this cluster is used for"
}

variable "eks_oidc_provider_arn" {
  type        = string
  description = "EKS openid connect provider ARN"
}

variable "cluster_endpoint" {
  type        = string
  description = "EKS cluster endpoint"
}

variable "cluster_ca_certificate" {
  type        = string
  description = "EKS cluster CA certificate"
}