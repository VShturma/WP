#-----/main.tf-----

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

#Configure VPC

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "true"

  tags = {
    Name = "WP"
  }
} 
