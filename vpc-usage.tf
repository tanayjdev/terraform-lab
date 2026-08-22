module "main_vpc" {
  source = "./modules/vpc"

  vpc_name = "terraform-mastery-${var.environment_name}"

  vpc_cidr = var.vpc_cidr_base

  azs = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  public_subnet_cidrs = [
    cidrsubnet(var.vpc_cidr_base, 8, 1),
    cidrsubnet(var.vpc_cidr_base, 8, 2)
  ]

  private_subnet_cidrs = [
    cidrsubnet(var.vpc_cidr_base, 8, 10),
    cidrsubnet(var.vpc_cidr_base, 8, 11)
  ]

  enable_nat_gateway = true

  tags = {
    Project     = "terraform-mastery"
    Environment = var.environment_name
  }
}