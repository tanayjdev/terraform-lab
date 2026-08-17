output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_arn" {
  value = aws_lb.this.arn
}

output "target_group_arn" {
  description = "ASG will attach to this via target_group_arns"
  value       = aws_lb_target_group.this.arn
}

output "alb_security_group_id" {
  description = "App-tier SG will allow ingress FROM this SG only"
  value       = aws_security_group.alb.id
}
