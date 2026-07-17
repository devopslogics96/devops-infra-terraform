variable "name" {
  description = "Base name for monitoring resources"
  type        = string
}

variable "environment" {
  description = "Environment tag value"
  type        = string
}

resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/eks/${var.name}/${var.environment}"
  retention_in_days = 30

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_sns_topic" "alerts" {
  name = "${var.name}-${var.environment}-alerts"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.app.name
}

output "sns_topic_arn" {
  description = "SNS topic ARN for alerting"
  value       = aws_sns_topic.alerts.arn
}
