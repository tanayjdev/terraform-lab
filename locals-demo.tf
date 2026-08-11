locals {

  environment_short = "dev"

  common_tags = {

    Project = "Terraform Mastery"

    ManagedBy = "Terraform"

    Environment = "Development"

  }

  instance_prefix = "terraform-dev"

}

output "common_tags" {

  value = local.common_tags

}

output "instance_prefix" {

  value = local.instance_prefix

}
