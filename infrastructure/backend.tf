terraform {
  backend "s3" {
    bucket         = "hero-vired-terraform-state"
    key            = "devops-infra-terraform/infrastructure/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "hero-vired-terraform-locks"
    encrypt        = true
  }
}
