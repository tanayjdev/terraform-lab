output "asg_name" {
  value = aws_autoscaling_group.this.name
}

output "app_security_group_id" {
  description = "Feed this into the RDS module's app_security_group_id going forward"
  value       = aws_security_group.app.id
}

output "launch_template_id" {
  value = aws_launch_template.this.id
}
