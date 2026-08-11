# ── Password Generation ──────────────────────────────────────

resource "random_password" "db_password" {
  length  = 24
  special = true

  # RDS PostgreSQL master password cannot contain:
  # / @ " or a space.
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


# ── DB Subnet Group ──────────────────────────────────────────

resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.project_name}-db-subnet-group"
  })
}


# ── Security Group — ONLY app tier reaches port 5432 ────────

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Allow PostgreSQL only from the application security group"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from app tier"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-rds-sg"
  })
}


# ── Custom Parameter Group ───────────────────────────────────

resource "aws_db_parameter_group" "this" {
  name   = "${var.project_name}-pg-params"
  family = "postgres15"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name         = "max_connections"
    value        = "100"
    apply_method = "pending-reboot"
  }

  tags = var.tags
}


# ── Secrets Manager — the secret container ───────────────────

resource "aws_secretsmanager_secret" "rds_credentials" {
  name        = "${var.project_name}-rds-credentials"
  description = "RDS master credentials for ${var.project_name} — managed by Terraform"

  tags = var.tags
}
