terraform {
  required_version = ">= 1.7.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_ami" "ubuntu" {
  count       = var.ami_id == "" ? 1 : 0
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

locals {
  selected_ami = var.ami_id != "" ? var.ami_id : data.aws_ami.ubuntu[0].id
}

# ── App-tier security group ─────────────────────────────────

resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Only ALB can reach the app port. No SSH ingress - SSM Session Manager is outbound-only."
  vpc_id      = var.vpc_id

  ingress {
    description     = "App traffic from ALB only"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    description = "Outbound for package installs, Secrets Manager, SSM (via NAT)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-app-sg"
  })
}

# ── IAM role ─────────────────────────────────────────────────

resource "aws_iam_role" "app_instance" {
  name = "${var.project_name}-app-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.app_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "secrets" {
  role       = aws_iam_role.app_instance.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_instance_profile" "app_instance" {
  name = "${var.project_name}-app-instance-profile"
  role = aws_iam_role.app_instance.name
}

# ── Launch Template ──────────────────────────────────────────

resource "aws_launch_template" "this" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = local.selected_ami
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.app_instance.name
  }

  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  user_data = base64encode(var.user_data)

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.tags, {
      Name = "${var.project_name}-app"
    })
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ── Auto Scaling Group ───────────────────────────────────────

resource "aws_autoscaling_group" "this" {
  name = "${var.project_name}-asg"

  vpc_zone_identifier = var.private_subnet_ids

  target_group_arns = [
    var.alb_target_group_arn
  ]

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-app"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = lookup(var.tags, "Environment", "unknown")
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ── Target-tracking scaling ─────────────────────────────────

resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name = "${var.project_name}-cpu-tracking"

  autoscaling_group_name = aws_autoscaling_group.this.name

  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.target_cpu_percent
  }
}
