resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "terraform-mastery-${var.environment_name}-overview"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/ApplicationELB",
              "RequestCount",
              "LoadBalancer",
              split("/", module.alb.alb_arn)[1]
            ]
          ]

          period = 300
          stat   = "Sum"
          region = "ap-south-1"
          title  = "ALB Requests"
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/ApplicationELB",
              "HealthyHostCount",
              "LoadBalancer",
              split("/", module.alb.alb_arn)[1]
            ]
          ]

          period = 300
          stat   = "Average"
          region = "ap-south-1"
          title  = "ALB Healthy Hosts"
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/RDS",
              "DatabaseConnections",
              "DBInstanceIdentifier",
              "terraform-mastery-${var.environment_name}-db"
            ]
          ]

          period = 300
          stat   = "Average"
          region = "ap-south-1"
          title  = "RDS Connections"
        }
      }
    ]
  })
}
