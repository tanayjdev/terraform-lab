resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [var.thumbprint]
}

# ─────────────────────────────────────────────────────────────
# PLAN ROLE
# Trust:
#   ONLY pull_request OIDC tokens from tanayjdev/terraform-lab
#   using this repository's current immutable subject format.
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

            "token.actions.githubusercontent.com:sub" = "repo:tanayjdev@162029870/terraform-lab@1331031814:pull_request"
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
# PLAN ROLE — Terraform remote state permissions
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
# Trust:
#   ONLY pushes to main
#
# Permissions:
#   AdministratorAccess
#
# IMPORTANT:
#   AdministratorAccess is intentionally being used only as the
#   learning/demo shortcut described in the Aug 14 curriculum.
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

            "token.actions.githubusercontent.com:sub" = "repo:tanayjdev@162029870/terraform-lab@1331031814:ref:refs/heads/main"
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