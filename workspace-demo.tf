data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

locals {
  environment_config = {
    dev = {
      instance_count = 1
      instance_type  = "t2.micro"
    }

    staging = {
      instance_count = 2
      instance_type  = "t2.micro"
    }

    production = {
      instance_count = 4
      instance_type  = "t2.small"
    }

    default = {
      instance_count = 1
      instance_type  = "t2.micro"
    }
  }

  current_config = local.environment_config[terraform.workspace]
}

resource "aws_instance" "app" {
  count = local.current_config.instance_count

  ami           = data.aws_ami.ubuntu.id
  instance_type = local.current_config.instance_type

  tags = {
    Name        = "app-${terraform.workspace}-${count.index}"
    Environment = terraform.workspace
  }
}
