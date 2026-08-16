variable "github_org" {
  description = "GitHub username or organization"
  type        = string
}

variable "github_repo" {
  description = "Repository name without owner prefix"
  type        = string
}

variable "github_org_id" {
  description = "Immutable numeric GitHub owner ID used in the OIDC subject"
  type        = string
}

variable "github_repo_id" {
  description = "Immutable numeric GitHub repository ID used in the OIDC subject"
  type        = string
}

variable "thumbprint" {
  description = "GitHub OIDC TLS thumbprint"
  type        = string
}
