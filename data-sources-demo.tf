################################################
# Current AWS Account
################################################

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

################################################
# Current Region
################################################

data "aws_region" "current" {}

output "current_region" {
  value = data.aws_region.current.name
}

################################################
# Availability Zones
################################################

data "aws_availability_zones" "available" {
  state = "available"
}

output "available_azs" {
  value = data.aws_availability_zones.available.names
}
