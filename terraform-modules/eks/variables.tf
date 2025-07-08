
variable "cluster_name" {
  type        = string
  description = "AWS EKS Cluster Name"
}

variable "environment" {
  type        = string
  description = "The name of the environment this cluster is used for"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnets ids for EKS cluster"
}

variable "eks_node_group_instance_types" {
  type        = string
  description = "The Instance type used for the eks workers"
}

variable "eks_node_group_desired_size" {
  type        = number
  description = "The desired number of woker nodes"
}
variable "eks_node_group_max_size" {
  type        = number
  description = "The maximum number of worker nodes"
}

variable "eks_node_group_min_size" {
  type        = number
  description = "The minimum number of worker nodes"
}


