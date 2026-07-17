variable "name" {
  description = "Base name for the bastion host"
  type        = string
}

variable "environment" {
  description = "Environment tag value"
  type        = string
}

variable "subnet_id" {
  description = "Public subnet ID where the bastion host will be created"
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs attached to the bastion host"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for the bastion host"
  type        = string
  default     = "t3.micro"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = true

  tags = {
    Name        = "${var.name}-${var.environment}-bastion"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

output "instance_id" {
  description = "ID of the bastion EC2 instance"
  value       = aws_instance.bastion.id
}

output "public_ip" {
  description = "Public IP address of the bastion EC2 instance"
  value       = aws_instance.bastion.public_ip
}
