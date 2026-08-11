variable "server_names" {

  type = list(string)

  default = [

    "web-1",

    "web-2",

    "api-1"

  ]

}

locals {

  uppercase_names = [

    for name in var.server_names :

    upper(name)

  ]

  web_servers = [

    for name in var.server_names :

    name

    if startswith(name, "web")

  ]

}
