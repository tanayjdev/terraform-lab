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

output "vpc_id" {
  value = module.main_vpc.vpc_id
}

output "public_subnets" {
  value = module.main_vpc.public_subnet_ids
}

output "private_subnets" {
  value = module.main_vpc.private_subnet_ids
}
