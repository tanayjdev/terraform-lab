output "configured_region" {

  value = var.region_name

}

output "server_names" {

  value = [
    for server in var.servers :
    server.name
  ]

}
