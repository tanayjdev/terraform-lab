data "aws_ami" "latest_packer_build" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "tag:BuiltBy"
    values = ["Packer"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

module "asg" {
  source = "./modules/asg"

  project_name = "terraform-mastery-${var.environment_name}"

  vpc_id = module.main_vpc.vpc_id

  private_subnet_ids = module.main_vpc.private_subnet_ids

  alb_target_group_arn = module.alb.target_group_arn

  alb_security_group_id = module.alb.alb_security_group_id

  ami_id = data.aws_ami.latest_packer_build.id

  instance_type    = var.asg_instance_type
  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity

  user_data = <<-EOF
    #!/bin/bash

    docker run -d \
      -p 5000:80 \
      --restart always \
      --name app \
      nginx:alpine

    sleep 5

    docker exec app sh -c 'echo "OK" > /usr/share/nginx/html/health'
  EOF

  tags = {
    Project     = "terraform-mastery"
    Environment = var.environment_name
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