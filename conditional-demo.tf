variable "environment" {

  type = string

  default = "dev"

}

locals {

  instance_type = var.environment == "production" ? "t3.large" : "t2.micro"

  instance_count = var.environment == "production" ? 3 : 1

}
