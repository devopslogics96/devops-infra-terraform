output "cluster_name" {
  description = "Name of the created EKS cluster"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS cluster"
  value       = aws_eks_cluster.this.endpoint
}

output "node_group_name" {
  description = "Name of the managed node group"
  value       = aws_eks_node_group.this.node_group_name
}
