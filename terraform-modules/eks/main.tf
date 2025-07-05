
# -> eks cluster
resource "aws_eks_cluster" "eks_cluster" {
    name = "${var.cluster_name}-${var.environment}"
    role_arn = aws_iam_role.eks_cluster_role.arn 
    vpc_config {
        subnet_ids = var.subnet_ids
    }
}

# -> eks node group properties
resource "aws_eks_node_group" "eks_node_group" {
    cluster_name = aws_eks_cluster.eks_cluster.name 
    node_group_name = "${var.cluster_name}-node-group-${var.environment}"
    node_role_arn = aws_iam_role.eks_node_group_role.arn
    subnet_ids = var.subnet_ids
    instance_types = [var.eks_node_group_instance_types]
    scaling_config {
        desired_size = var.eks_node_group_desired_size
        max_size     = var.eks_node_group_max_size
        min_size     = var.eks_node_group_min_size
    }
}

# resource "" "" {}