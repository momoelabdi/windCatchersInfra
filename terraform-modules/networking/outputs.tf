
output "private_subnets_ids" {
  value     = aws_subnet.private[*].id
  sensitive = true
}

output "eks_vpc_id" {
  value     = aws_vpc.eks_vpc.id
  sensitive = true
}

output "private_subnet_cidr_blocks" {
  value     = [for subnet in aws_subnet.private : subnet.cidr_block]
  sensitive = true
}
