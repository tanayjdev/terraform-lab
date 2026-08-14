module "app_instance" {
  source = "./modules/app-instance"

  instance_type = "t2.micro"
  environment   = terraform.workspace
}
