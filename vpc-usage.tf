module "main_vpc" {
  source = "./modules/vpc"

  vpc_name = "august-terraform-vpc"

  vpc_cidr = "10.1.0.0/16"

  azs = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  public_subnet_cidrs = [
    "10.1.1.0/24",
    "10.1.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.1.10.0/24",
    "10.1.11.0/24"
  ]

  enable_nat_gateway = false

  tags = {
    Project     = "terraform-mastery"
    Environment = "learning"
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
