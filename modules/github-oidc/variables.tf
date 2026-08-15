variable "github_org" {
  description = "GitHub username or organization"
  type        = string
}

variable "github_repo" {
  description = "Repository name without owner prefix"
  type        = string
}

variable "thumbprint" {
  description = "GitHub OIDC TLS thumbprint"
  type        = string
}
