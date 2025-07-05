

module "eks" {
    source = "../../../terraform-modules/eks"
    cluster_name = var.cluster_name
    environment = var.environment
    subnet_ids = var.subnet_ids # network module outpout
    eks_node_group_instance_types = var.eks_node_group_instance_types
    eks_node_group_desired_size = var.eks_node_group_desired_size
    eks_node_group_max_size = var.eks_node_group_max_size
    eks_node_group_min_size = var.eks_node_group_min_size
}

# module "network" {
#     source = "terraform-modules/networking"
# }
