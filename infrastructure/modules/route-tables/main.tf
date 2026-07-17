variable "vpc_id" {
  description = "VPC ID for the route tables"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "internet_gateway_id" {
  description = "Internet gateway ID for the public route table"
  type        = string
}

variable "nat_gateway_ids" {
  description = "NAT gateway IDs for the private route tables"
  type        = list(string)
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name      = "public-route-table"
    ManagedBy = "Terraform"
  }
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_ids)
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnet_ids)
  vpc_id = var.vpc_id

  tags = {
    Name      = "private-route-table-${count.index + 1}"
    ManagedBy = "Terraform"
  }
}

resource "aws_route" "private_default" {
  count                  = length(var.private_subnet_ids)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = length(var.nat_gateway_ids) > 0 ? var.nat_gateway_ids[count.index % length(var.nat_gateway_ids)] : null
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_ids)
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private[count.index].id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "IDs of the private route tables"
  value       = aws_route_table.private[*].id
}
