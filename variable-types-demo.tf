############################
# Primitive Types
############################

variable "region_name" {
  type    = string
  default = "ap-south-1"
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "enable_monitoring" {
  type    = bool
  default = true
}

############################
# Collection Types
############################

variable "availability_zones" {
  type = list(string)

  default = [
    "ap-south-1a",
    "ap-south-1b",
    "ap-south-1c"
  ]
}

variable "demo_allowed_ports" {
  type = set(number)

  default = [
    22,
    80,
    443
  ]
}

variable "instance_types" {
  type = map(string)

  default = {
    dev  = "t2.micro"
    prod = "t2.large"
  }
}

############################
# Structural Types
############################

variable "server_config" {

  type = object({
    name          = string
    instance_type = string
    disk_size     = number
    monitoring    = bool
  })

  default = {
    name          = "web-server"
    instance_type = "t2.micro"
    disk_size     = 20
    monitoring    = true
  }
}

variable "server_details" {

  type = tuple([
    string,
    number,
    bool
  ])

  default = [
    "web-server",
    20,
    true
  ]
}

############################
# List of Objects
############################

variable "servers" {

  type = list(object({

    name          = string
    instance_type = string
    role          = string

  }))

  default = [

    {
      name          = "web-1"
      instance_type = "t2.micro"
      role          = "web"
    },

    {
      name          = "api-1"
      instance_type = "t2.small"
      role          = "api"
    }

  ]
}

############################
# Any Type
############################

variable "flexible_config" {
  type = any
}
