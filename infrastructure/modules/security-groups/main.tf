variable "name" {
  description = "Base name for the security groups"
  type        = string
}

variable "environment" {
  description = "Environment tag value"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the security groups"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

resource "aws_security_group" "bastion" {
  name        = "${var.name}-${var.environment}-bastion-sg"
  description = "Allow SSH to the bastion host"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-${var.environment}-bastion-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_security_group" "eks_nodes" {
  name        = "${var.name}-${var.environment}-eks-node-sg"
  description = "Allow internal access to EKS worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-${var.environment}-eks-node-sg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

output "bastion_sg_id" {
  description = "Security group ID for the bastion host"
  value       = aws_security_group.bastion.id
}

output "eks_node_sg_id" {
  description = "Security group ID for the EKS worker nodes"
  value       = aws_security_group.eks_nodes.id
}
