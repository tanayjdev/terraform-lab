variable "test_var" {

  type = string

  default = "default-value"

}

output "test_output" {

  value = var.test_var

}
