#-----/variables.tf-----

variable "aws_access_key" {}
variable "aws_secret_key" {}

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

variable "db_count" {
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

variable "db_subnets" {
  description = "List of CIDR blocks for DB(isolated) subnets."
  type = "list"
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}
