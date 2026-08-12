output "db_endpoint" {
  description = "Full connection endpoint (host:port)"
  value       = aws_db_instance.this.endpoint
}

output "db_address" {
  description = "Hostname only, no port"
  value       = aws_db_instance.this.address
}

output "db_port" {
  value = aws_db_instance.this.port
}

output "db_name" {
  value = aws_db_instance.this.db_name
}

output "secret_arn" {
  description = "Fetch credentials at runtime via this ARN"
  value       = aws_secretsmanager_secret.rds_credentials.arn
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}
