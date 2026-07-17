variable "name" {
  description = "Base name for the IAM resources"
  type        = string
}

variable "environment" {
  description = "Environment tag value"
  type        = string
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ci" {
  name               = "${var.name}-${var.environment}-ci-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    Name        = "${var.name}-${var.environment}-ci-role"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_policy" "ecr_and_ec2" {
  name = "${var.name}-${var.environment}-ecr-ec2"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ec2:DescribeInstances",
          "ec2:DescribeTags"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ci" {
  role       = aws_iam_role.ci.name
  policy_arn = aws_iam_policy.ecr_and_ec2.arn
}

output "role_arn" {
  description = "ARN of the CI role"
  value       = aws_iam_role.ci.arn
}

output "role_name" {
  description = "Name of the CI role"
  value       = aws_iam_role.ci.name
}
