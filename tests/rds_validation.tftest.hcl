run "valid_config_plans_successfully" {
  command = plan

  module {
    source = "./modules/rds"
  }

  variables {
    project_name          = "test-rds"
    vpc_id                = "vpc-0123456789abcdef0"
    private_subnet_ids    = ["subnet-aaaaaaaa", "subnet-bbbbbbbb"]
    app_security_group_id = "sg-xxxxxxxxxxxxxxxxx"
    alert_email           = "test@example.com"
  }

  assert {
    condition     = aws_db_instance.this.storage_encrypted == true
    error_message = "RDS instance must always have storage_encrypted = true"
  }

  assert {
    condition     = aws_db_instance.this.publicly_accessible == false
    error_message = "RDS instance must never be publicly accessible"
  }

  assert {
    condition     = aws_db_instance.this.storage_type == "gp3"
    error_message = "RDS must use gp3 storage, not gp2"
  }
}

run "rejects_single_subnet" {
  command = plan

  module {
    source = "./modules/rds"
  }

  variables {
    project_name          = "test-rds"
    vpc_id                = "vpc-0123456789abcdef0"
    private_subnet_ids    = ["subnet-aaaaaaaa"]
    app_security_group_id = "sg-xxxxxxxxxxxxxxxxx"
    alert_email           = "test@example.com"
  }

  expect_failures = [
    var.private_subnet_ids,
  ]
}

run "rejects_invalid_email" {
  command = plan

  module {
    source = "./modules/rds"
  }

  variables {
    project_name          = "test-rds"
    vpc_id                = "vpc-0123456789abcdef0"
    private_subnet_ids    = ["subnet-aaaaaaaa", "subnet-bbbbbbbb"]
    app_security_group_id = "sg-xxxxxxxxxxxxxxxxx"
    alert_email           = "not-an-email-at-all"
  }

  expect_failures = [
    var.alert_email,
  ]
}
