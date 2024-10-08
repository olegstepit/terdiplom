 provider "aws" {
  region     = "eu-central-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
 
locals {
  name   = "kubuk-testr"
  region = "eu-central-1"
 
  vpc_cidr = "10.123.0.0/16"
  azs      = ["eu-central-1a", "eu-central-1b"]
 
  public_subnets  = ["10.123.1.0/24", "10.123.2.0/24"]
  private_subnets = ["10.123.3.0/24", "10.123.4.0/24"]
  intra_subnets   = ["10.123.5.0/24", "10.123.6.0/24"]
}
 
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"
 
  name = local.name
  cidr = local.vpc_cidr
 
  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  intra_subnets   = local.intra_subnets
 
  enable_nat_gateway = true
}
 
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.1"
 
  cluster_name                   = local.name
  cluster_endpoint_public_access = true
 
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets
 
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.medium"]
    attach_cluster_primary_security_group = true
  }
 
  eks_managed_node_groups = {
    ascode-cluster-wg = {
      min_size     = 1
      max_size     = 3
      desired_size = 1
 
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }
}