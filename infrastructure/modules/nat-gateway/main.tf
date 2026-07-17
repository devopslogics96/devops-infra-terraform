variable "name" {
  description = "Base name for NAT Gateway resources"
  type        = string
}

variable "environment" {
  description = "Environment tag value"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs where NAT gateways will be created"
  type        = list(string)
}

resource "aws_eip" "nat" {
  count  = length(var.public_subnet_ids)
  domain = "vpc"

  tags = {
    Name        = "${var.name}-${var.environment}-nat-eip-${count.index + 1}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.public_subnet_ids)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]

  tags = {
    Name        = "${var.name}-${var.environment}-nat-${count.index + 1}"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

output "nat_gateway_ids" {
  description = "IDs of the created NAT gateways"
  value       = aws_nat_gateway.nat[*].id
}
