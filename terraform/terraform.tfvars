aws_region   = "us-east-1"
instance_type = "t3.micro"
key_name      = "autohealing-key"
ami_id        = "ami-08a6efd148b1f7504"
vpc_cidr      = "10.0.0.0/16"
subnet_count  = 2
asg_min_size  = 1
asg_max_size  = 1
