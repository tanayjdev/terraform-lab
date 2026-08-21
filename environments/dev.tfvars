environment_name     = "dev"
vpc_cidr_base        = "10.1.0.0/16"
asg_instance_type    = "t3.micro"
asg_min_size         = 1
asg_max_size         = 2
asg_desired_capacity = 1
rds_instance_class   = "db.t3.micro"
rds_multi_az         = false
