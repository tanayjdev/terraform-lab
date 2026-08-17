variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "alb_target_group_arn" {
  type = string
}

variable "alb_security_group_id" {
  description = "Only this SG's traffic is allowed to reach the app port"
  type        = string
}

variable "ami_id" {
  description = "Leave empty to auto-fetch latest Ubuntu. Will be a Packer AMI from Aug 20 onward."
  type        = string
  default     = ""
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "app_port" {
  type    = number
  default = 5000
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "target_cpu_percent" {
  description = "Target-tracking scaling: ASG adds/removes instances to hold average CPU near this value"
  type        = number
  default     = 60
}

variable "user_data" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
