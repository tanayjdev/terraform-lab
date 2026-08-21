environment_name     = "prod"
vpc_cidr_base        = "10.2.0.0/16"
asg_instance_type    = "t3.small"
asg_min_size         = 2
asg_max_size         = 4
asg_desired_capacity = 2
rds_instance_class   = "db.t3.small"
rds_multi_az         = true
