variable "server_count" {

  type = number

  default = 2

  validation {

    condition = var.server_count > 0 && var.server_count <= 10

    error_message = "Server count must be between 1 and 10."

  }
}
