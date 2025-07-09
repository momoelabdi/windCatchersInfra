

module "eks" {
  source                        = "../../../terraform-modules/eks"
  cluster_name                  = var.cluster_name
  environment                   = var.environment
  subnet_ids                    = module.network.private_subnets_ids
  eks_node_group_instance_types = var.eks_node_group_instance_types
  eks_node_group_desired_size   = var.eks_node_group_desired_size
  eks_node_group_max_size       = var.eks_node_group_max_size
  eks_node_group_min_size       = var.eks_node_group_min_size
}


module "network" {
  source       = "../../../terraform-modules/networking"
  cluster_name = "${var.cluster_name}-${var.environment}"
}

module "loadbalancer" {
  source       = "../../../terraform-modules/loadbalancer"
  cluster_name = "${var.cluster_name}-${var.environment}"
  environment                   = var.environment
  cluster_ca_certificate = module.eks.cluster_ca_certificate
  eks_oidc_provider_arn = module.eks.eks_oidc_provider_arn
  cluster_endpoint = module.eks.cluster_endpoint
  vpc_id = module.network.eks_vpc_id
}