variable "db_password" {
  type      = string
  sensitive = true
  nullable  = true
  default   = null
}

output "database_password" {
  value     = var.db_password
  sensitive = true
}
