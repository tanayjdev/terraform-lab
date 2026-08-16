module "github_oidc" {
  source = "./modules/github-oidc"

  github_org     = "tanayjdev"
  github_repo    = "terraform-lab"
  github_org_id  = "162029870"
  github_repo_id = "1331031814"

  thumbprint = "227203b5317f3818cab5b5ce596132bf36748c0e"
}

output "plan_role_arn" {
  value = module.github_oidc.plan_role_arn
}

output "apply_role_arn" {
  value = module.github_oidc.apply_role_arn
}