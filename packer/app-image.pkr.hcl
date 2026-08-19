packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1.3"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "git_commit" {
  type    = string
  default = "unknown"
}

source "amazon-ebs" "ubuntu" {
  region        = var.aws_region
  instance_type = var.instance_type

  ami_name = "terraform-mastery-app-{{timestamp}}"
  ami_description = "Built from commit ${var.git_commit}"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }

    owners      = ["099720109477"]
    most_recent = true
  }

  ssh_username = "ubuntu"

  tags = {
    Name     = "terraform-mastery-app"
    BuiltBy  = "Packer"
    BuildDate = "{{timestamp}}"
  }
}

build {
  name    = "app-image"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y docker.io curl",
      "sudo systemctl enable docker",
      "sudo usermod -aG docker ubuntu"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'Image built via Packer on' $(date) | sudo tee /etc/packer-build-info"
    ]
  }
  provisioner "shell" {
    inline = [
      "docker --version || (echo 'DOCKER INSTALL VERIFICATION FAILED' && exit 1)"
    ]
  }
}
