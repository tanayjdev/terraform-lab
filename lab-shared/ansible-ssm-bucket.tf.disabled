resource "aws_s3_bucket" "ansible_ssm_transfer" {
  bucket = "tanay-ansible-ssm-transfer-2026"

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Purpose   = "Ansible SSM connection plugin file transfer"
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "ansible_ssm_cleanup" {
  bucket = aws_s3_bucket.ansible_ssm_transfer.id

  rule {
    id     = "expire-old-transfers"
    status = "Enabled"

    filter {}

    expiration {
      days = 1
    }
  }
}

output "ansible_ssm_bucket" {
  value = aws_s3_bucket.ansible_ssm_transfer.id
}