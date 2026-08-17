variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  description = "Minimum 2, different AZs — ALB requirement, same as RDS subnet group rule"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "ALB requires subnets in at least 2 Availability Zones."
  }
}

variable "target_port" {
  description = "Port the app listens on inside the instance"
  type        = number
  default     = 5000
}

variable "health_check_path" {
  type    = string
  default = "/health"
}

variable "tags" {
  type    = map(string)
  default = {}
}
