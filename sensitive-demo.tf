variable "db_password" {

  type = string

  sensitive = true
}

output "database_password" {

  value = var.db_password

  sensitive = true

}
