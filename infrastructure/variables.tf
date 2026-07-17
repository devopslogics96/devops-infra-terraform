variable "project_name" {
  description = "Name prefix for the infrastructure resources"
  type        = string
  default     = "hero-vired"
}

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Target environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the base VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
}

variable "node_instance_type" {
  description = "EC2 instance type for the EKS managed node group"
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "Desired worker node count"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum worker node count"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum worker node count"
  type        = number
  default     = 3
}
