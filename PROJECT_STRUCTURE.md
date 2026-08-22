# Project File Layout

## Root-level files
- `main.tf` — provider + terraform block
- `backend.tf` — S3+DynamoDB remote state config
- `environment-vars.tf` — root variables consumed by *-usage.tf files
- `*-usage.tf` — one file per module call (vpc, alb, asg, rds, github-oidc). Each wires that module into the overall stack.
- `ansible-ssm-bucket.tf` — supporting S3 bucket for Ansible's SSM connection plugin (transient, 1-day lifecycle)

## modules/
- `vpc/` — networking foundation
- `alb/` — load balancer
- `asg/` — compute (autoscaling)
- `rds/` — database
- `github-oidc/` — CI identity federation
- `app-instance/`, `ec2/` — DEPRECATED (superseded by asg/ on Aug 17, kept for module-refactoring practice history, not called from root)

## environments/
Per-environment tfvars — dev.tfvars, prod.tfvars

## tests/
Native `.tftest.hcl` coverage (Aug 13)

## packer/, ansible/
Separate tool workflows, not Terraform-managed directly
