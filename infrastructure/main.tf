locals {
  cluster_name = "${var.environment}-eks"
}

module "vpc" {
  source = "./modules/vpc"

  name                 = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security_groups" {
  source = "./modules/security-groups"

  name        = var.project_name
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = var.vpc_cidr
}

module "nat_gateway" {
  source = "./modules/nat-gateway"

  name              = var.project_name
  environment       = var.environment
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "route_tables" {
  source = "./modules/route-tables"

  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  private_subnet_ids  = module.vpc.private_subnet_ids
  internet_gateway_id = module.vpc.internet_gateway_id
  nat_gateway_ids     = module.nat_gateway.nat_gateway_ids
}

module "iam" {
  source = "./modules/iam"

  name        = var.project_name
  environment = var.environment
}

module "bastion" {
  source = "./modules/bastion"

  name               = var.project_name
  environment        = var.environment
  subnet_id          = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.security_groups.bastion_sg_id]
  instance_type      = "t3.micro"
}

module "s3_backend" {
  source = "./modules/s3-backend"

  bucket_name         = "${var.project_name}-${var.environment}-tfstate"
  dynamodb_table_name = "${var.project_name}-${var.environment}-tf-locks"
  environment         = var.environment
}

module "ecr" {
  source = "./modules/ecr"

  repository_name = "${var.project_name}-${var.environment}-app"
}

module "monitoring" {
  source = "./modules/monitoring"

  name        = var.project_name
  environment = var.environment
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = local.cluster_name
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = module.vpc.private_subnet_ids
  node_instance_type = var.node_instance_type
  desired_capacity   = var.desired_capacity
  min_size           = var.min_size
  max_size           = var.max_size
}
