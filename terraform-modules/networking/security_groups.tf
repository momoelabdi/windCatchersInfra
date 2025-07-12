# -> security groups for EKS cluster 

# -> SG for eks control plane communication with worker nodes
resource "aws_security_group" "eks_cluster_sg" {
  name   = "${var.cluster_name}-sg"
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "${var.cluster_name}-sg"
  }
}
 
# -> SG for worker nodes in the eks cluster
resource "aws_security_group" "eks_nodes_sg" {
  name   = "${var.cluster_name}-nodes-sg"
  vpc_id = aws_vpc.eks_vpc.id
  tags = {
    Name = "${var.cluster_name}-nodes-sg"
  }
}

# -> allow inbound traffic from the workers to the k8s api-server
resource "aws_security_group_rule" "eks_cluster_ingress" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_nodes_sg.id
  description              = "allow inbound traffic from the workers to the k8s api-server port 443"
}

# -> allow egress from the control plane to the node for the kubelet
resource "aws_security_group_rule" "eks_cluster_egress" {
  type                     = "egress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_sg.id
  source_security_group_id = aws_security_group.eks_nodes_sg.id
  description              = "Allow egress from the control plane to the node for the kubelet"
}

# -> allow ingress from the control plane to the node for the kubelet
resource "aws_security_group_rule" "eks_nodes_egress" {
  type                     = "ingress"
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  source_security_group_id = aws_security_group.eks_cluster_sg.id
  description              = "Allow ingress from the control plane to the node for the kubelet"
}

# -> allow ephemeral communication between nodes
resource "aws_security_group_rule" "eks_nodes_to_nodes" {
  type              = "ingress"
  from_port         = 1025
  to_port           = 65535
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.eks_nodes_sg.id
  description       = "Allow worker nodes to communicate with each other using ephemeral ports"
}

# -> allow nodes outbound internet access 
resource "aws_security_group_rule" "nodes_egress_to_internet" {
  type              = "egress" 
  from_port         =  0
  to_port           =  0
  protocol          = "-1" 
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_nodes_sg.id
  description       = "Allow nodes outbound internet access"
}

# -> allow worker nodes to access DNS server over tcp
resource "aws_security_group_rule" "nodes_to_node_coredns_tcp" {
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_nodes_sg.id
  self              = true
  description       = "Allow worker nodes to access DNS server over tcp"
}

# -> allow worker nodes to access DNS server over UDP
resource "aws_security_group_rule" "nodes_to_node_coredns_udp" {
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  security_group_id = aws_security_group.eks_nodes_sg.id
  self              = true
  description       = "Allow worker nodes to access DNS server over udp"
}

