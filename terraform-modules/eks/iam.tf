# -> EKS cluster IAM role 
resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.cluster_name}-iam-role"
  assume_role_policy = data.aws_iam_policy_document.cluster_policy_document.json
}

# -> cluster policy Document
data "aws_iam_policy_document" "cluster_policy_document" {
  statement {

    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "attach_role_to_cluster" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# -> EKS node group iam role 
resource "aws_iam_role" "eks_node_group_role" {
  name               = "${var.cluster_name}-node-group-iam-role"
  assume_role_policy = data.aws_iam_policy_document.node_group_policy_document.json
}

# -> Node group 
data "aws_iam_policy_document" "node_group_policy_document" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# ->  EKS worker policies 
resource "aws_iam_role_policy_attachment" "eks_node_group_policy" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_group_cni_policy" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_node_group_ECR_policy" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}