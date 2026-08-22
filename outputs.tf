# Networking

output "vpc_id" {
  value = module.main_vpc.vpc_id
}

# Compute

output "asg_name" {
  value = module.asg.asg_name
}

output "app_security_group_id" {
  value = module.asg.app_security_group_id
}

# Load Balancer

output "alb_url" {
  value = "http://${module.alb.alb_dns_name}"
}

# Database

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "rds_secret_arn" {
  value = module.rds.secret_arn
}
