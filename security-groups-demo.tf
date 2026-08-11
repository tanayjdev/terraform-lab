variable "allowed_ports" {
  type = map(object({
    port        = number
    description = string
  }))
  default = {
    ssh   = { port = 22, description = "SSH access" }
    http  = { port = 80, description = "HTTP access" }
    https = { port = 443, description = "HTTPS access" }
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "demo_sg" {
  name        = "terraform-demo-sg"
  description = "Demonstrates for_each in security group rules"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
