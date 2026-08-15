module "github_oidc" {
  source = "./modules/github-oidc"

  github_org  = "tanayjdev"
  github_repo = "terraform-mastery"

  thumbprint = "227203b5317f3818cab5b5ce596132bf36748c0e"
}

output "plan_role_arn" {
  value = module.github_oidc.plan_role_arn
}

output "apply_role_arn" {
  value = module.github_oidc.apply_role_arn
}
