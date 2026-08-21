module "rds" {
  source = "./modules/rds"

  project_name          = "terraform-mastery-${var.environment_name}"
  vpc_id                = module.main_vpc.vpc_id
  private_subnet_ids    = module.main_vpc.private_subnet_ids
  app_security_group_id = module.asg.app_security_group_id
  alert_email           = "tanayj489@gmail.com"

  # Use the PostgreSQL version that actually succeeded in your
  # ap-south-1 deployment.
  engine_version        = "15.18"
  instance_class        = var.rds_instance_class
  allocated_storage     = 20
  max_allocated_storage = 100
  multi_az              = var.rds_multi_az
  skip_final_snapshot   = true
  deletion_protection   = false

  tags = {
    Project     = "terraform-mastery"
    Environment = terraform.workspace
    ManagedBy   = "Terraform"
  }
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "rds_secret_arn" {
  value = module.rds.secret_arn
}

output "rds_security_group_id" {
  value = module.rds.rds_security_group_id
}
