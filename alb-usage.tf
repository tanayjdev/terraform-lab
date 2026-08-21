module "alb" {
  source = "./modules/alb"

  project_name      = "terraform-mastery-${var.environment_name}"
  vpc_id            = module.main_vpc.vpc_id
  public_subnet_ids = module.main_vpc.public_subnet_ids

  target_port       = 5000
  health_check_path = "/health"

  tags = {
    Project     = "terraform-mastery"
    Environment = terraform.workspace
  }
}

output "alb_url" {
  value = "http://${module.alb.alb_dns_name}"
}

output "alb_target_group_arn" {
  value = module.alb.target_group_arn
}