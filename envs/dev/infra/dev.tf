
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



# > VPC  config for the eks cluster 
module "network" {
  source               = "../../../terraform-modules/networking"
  cluster_name         = "${var.cluster_name}-${var.environment}"
  count_public_subnet  = var.count_public_subnet
  count_private_subnet = var.count_private_subnet
  cidr_block           = var.cidr_block
}

# > aws load balancer controller deployment for the eks cluster loadbalancing
module "loadbalancer" {
  source                 = "../../../terraform-modules/loadbalancer"
  cluster_name           = "${var.cluster_name}-${var.environment}"
  environment            = var.environment
  cluster_ca_certificate = module.eks.cluster_ca_certificate
  eks_oidc_provider_arn  = module.eks.eks_oidc_provider_arn
  cluster_endpoint       = module.eks.cluster_endpoint
  vpc_id                 = module.network.eks_vpc_id
}


module "database" {
  source                      = "../../../terraform-modules/database"
  db_identifier               = var.db_identifier
  environment                 = var.environment
  db_instance_class           = var.db_instance_class
  db_engine_version           = var.db_engine_version
  db_username                 = var.db_username
  db_password                 = var.db_password
  db_name                     = var.db_name
  db_subnet_ids               = module.network.private_subnets_ids
  eks_nodes_security_group_id = module.network.eks_nodes_security_group_id
  vpc_id                      = module.network.eks_vpc_id
}