variable "environment_name" {
  type = string
}

variable "vpc_cidr_base" {
  type = string
}

variable "asg_instance_type" {
  type = string
}

variable "asg_min_size" {
  type = number
}

variable "asg_max_size" {
  type = number
}

variable "asg_desired_capacity" {
  type = number
}

variable "rds_instance_class" {
  type = string
}

variable "rds_multi_az" {
  type = bool
}
