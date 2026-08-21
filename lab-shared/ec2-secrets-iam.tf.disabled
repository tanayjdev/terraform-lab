data "aws_caller_identity" "current_account" {}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "web_server_secrets" {
  name = "terraform-mastery-web-server-secrets-role"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Project     = "terraform-mastery"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

data "aws_iam_policy_document" "web_server_secrets" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      "arn:aws:secretsmanager:ap-south-1:${data.aws_caller_identity.current_account.account_id}:secret:terraform-mastery-rds-credentials-*"
    ]
  }
}

resource "aws_iam_role_policy" "web_server_secrets" {
  name   = "read-rds-credentials"
  role   = aws_iam_role.web_server_secrets.id
  policy = data.aws_iam_policy_document.web_server_secrets.json
}

resource "aws_iam_instance_profile" "web_server" {
  name = "terraform-mastery-web-server-profile"
  role = aws_iam_role.web_server_secrets.name

  tags = {
    Project     = "terraform-mastery"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
