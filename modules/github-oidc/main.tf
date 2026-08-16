resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [var.thumbprint]
}

# ─────────────────────────────────────────────────────────────
# PLAN ROLE
#
# Trust:
#   ONLY pull_request OIDC tokens from this GitHub repository.
#
# OIDC subject format currently issued by GitHub:
#   repo:<org>@<org_id>/<repo>@<repo_id>:pull_request
#
# Permissions:
#   ReadOnlyAccess
#   +
#   Terraform remote-state S3/DynamoDB access
# ─────────────────────────────────────────────────────────────

resource "aws_iam_role" "terraform_plan" {
  name = "github-actions-terraform-plan"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.github_actions.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"

            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}@${var.github_org_id}/${var.github_repo}@${var.github_repo_id}:pull_request"
          }
        }
      }
    ]
  })
}

# Read-only AWS permissions for Terraform PLAN.
resource "aws_iam_role_policy_attachment" "plan_readonly" {
  role       = aws_iam_role.terraform_plan.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# ─────────────────────────────────────────────────────────────
# PLAN ROLE — Terraform remote-state permissions
#
# backend.tf:
#   S3 bucket  = tanayjdev-tf-state-2026-464975960111
#   State key  = terraform-mastery/terraform.tfstate
#   Lock table = terraform-state-locks
# ─────────────────────────────────────────────────────────────

resource "aws_iam_role_policy" "plan_backend" {
  name = "github-actions-terraform-plan-backend"
  role = aws_iam_role.terraform_plan.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]

        Resource = "arn:aws:dynamodb:ap-south-1:464975960111:table/terraform-state-locks"
      },

      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]

        Resource = "arn:aws:s3:::tanayjdev-tf-state-2026-464975960111/terraform-mastery/terraform.tfstate"
      },

      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = "arn:aws:s3:::tanayjdev-tf-state-2026-464975960111"

        Condition = {
          StringLike = {
            "s3:prefix" = [
              "terraform-mastery/*"
            ]
          }
        }
      }
    ]
  })
}

# ─────────────────────────────────────────────────────────────
# APPLY ROLE
#
# Trust:
#   ONLY pushes to main.
#
# OIDC subject format:
#   repo:<org>@<org_id>/<repo>@<repo_id>:ref:refs/heads/main
#
# Permissions:
#   AdministratorAccess
#
# IMPORTANT:
#   AdministratorAccess is intentionally used only as the
#   learning/demo shortcut from the Aug 14 curriculum.
#   It is NOT production-safe.
# ─────────────────────────────────────────────────────────────

resource "aws_iam_role" "terraform_apply" {
  name = "github-actions-terraform-apply"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.github_actions.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"

            "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}@${var.github_org_id}/${var.github_repo}@${var.github_repo_id}:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apply_admin" {
  role       = aws_iam_role.terraform_apply.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}