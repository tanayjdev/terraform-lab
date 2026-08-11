module "web_server" {
  source = "./modules/ec2"

  instance_name    = "web-server"
  instance_type    = "t2.micro"
  subnet_id        = module.main_vpc.public_subnet_ids[0]
  vpc_id           = module.main_vpc.vpc_id
  allowed_ssh_cidr = "0.0.0.0/0" # For learning only. In production, use your public IP.

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
  EOF

  tags = {
    Project     = "terraform-mastery"
    Environment = "learning"
  }
}

output "web_server_public_ip" {
  value = module.web_server.public_ip
}
