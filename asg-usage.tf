module "asg" {
  source = "./modules/asg"

  project_name = "terraform-mastery"

  vpc_id = module.main_vpc.vpc_id

  private_subnet_ids = module.main_vpc.private_subnet_ids

  alb_target_group_arn = module.alb.target_group_arn

  alb_security_group_id = module.alb.alb_security_group_id

  min_size         = 1
  max_size         = 3
  desired_capacity = 1

  user_data = <<-EOF
    #!/bin/bash

    apt-get update -y
    apt-get install -y nginx

    # Aug 15 ALB target group listens on port 5000.
    # Make nginx listen on the same port.
    sed -i 's/listen 80 default_server;/listen 5000 default_server;/' /etc/nginx/sites-available/default
    sed -i 's/listen \[::\]:80 default_server;/listen [::]:5000 default_server;/' /etc/nginx/sites-available/default

    echo "OK" > /var/www/html/health

    nginx -t
    systemctl enable nginx
    systemctl restart nginx
  EOF

  tags = {
    Project     = "terraform-mastery"
    Environment = terraform.workspace
  }
}

output "app_security_group_id" {
  description = "ID of the application security group"
  value       = module.asg.app_security_group_id
}

output "asg_name" {
  description = "Name of the application Auto Scaling Group"
  value       = module.asg.asg_name
}

output "launch_template_id" {
  description = "ID of the application Launch Template"
  value       = module.asg.launch_template_id
}

output "target_group_arn" {
  description = "ARN of the ALB target group used by the Auto Scaling Group"
  value       = module.alb.target_group_arn
}