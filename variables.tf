#-----/variables.tf-----

variable "aws_region" {
  default = "eu-central-1"
}

variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "vpc_name" {
  description = "Name of a new VPC."
  default = "WP"
}

variable "vpc_subnet" {
	description = "CIDR block for a new VPC."
  default = "10.0.0.0/16"
}

variable "vpc_tenancy" {
  description = "VPC tenancy value (default or dedicated)."
  default = "default"
}

variable "dmz_count" {
  description = "Number of DMZ subnets."
  default = 2
}

variable "app_count" {
  description = "Number of APP subnets."
  default = 2
}

variable "data_count" {
  description = "Number of DB subnets."
  default = 2 
}

variable "dmz_subnets" {
  description = "List of CIDR blocks for DMZ(public) subnets."
  type = "list"
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "app_subnets" {
  description = "List of CIDR blocks for APP(private) subnets."
  type = "list"
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "data_subnets" {
  description = "List of CIDR blocks for Data(isolated) subnets."
  type = "list"
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "ssh_access_ips" {
  description = "List of IPs that can SSH to a Bastion host."
  type = "list"
}

variable "web_access_ips" {
  description = "List of IPs that can acess web resources via HTTP/HTTPS."
  type = "list"
  default = ["0.0.0.0/0"]
}

