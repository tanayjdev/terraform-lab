run "vpc_creates_correct_network" {
  command = apply

  module {
    source = "./modules/vpc"
  }

  variables {
    vpc_name            = "tftest-vpc"
    vpc_cidr            = "10.99.0.0/16"
    azs                 = ["ap-south-1a", "ap-south-1b"]
    public_subnet_cidrs = ["10.99.1.0/24", "10.99.2.0/24"]
    private_subnet_cidrs = [
      "10.99.10.0/24",
      "10.99.11.0/24",
    ]
    enable_nat_gateway = false
  }

  assert {
    condition     = aws_vpc.this.cidr_block == "10.99.0.0/16"
    error_message = "VPC CIDR does not match what was requested"
  }

  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "Expected exactly 2 public subnets"
  }

  assert {
    condition     = length(aws_subnet.private) == 2
    error_message = "Expected exactly 2 private subnets"
  }
}
