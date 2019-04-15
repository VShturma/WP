#-----/networking/variables.tf-----

variable "vpc_name" {
	description = "Name of a new VPC."
}

variable "vpc_subnet" {
	description = "CIDR block for a new VPC."
}

variable "vpc_tenancy" {
	description = "VPC tenancy value (default or dedicated)."
}

variable "dmz_count" {
	description = "Number of DMZ subnets."
}

variable "app_count" {
	description = "Number of APP subnets."
}

variable "db_count" {
	description = "Number of DB subnets."
}

variable "dmz_subnets" {
	description = "List of CIDR blocks for DMZ(public) subnets."
	type = "list"
}

variable "app_subnets" {
	description = "List of CIDR blocks for APP(private) subnets."
	type = "list"
}

variable "db_subnets" {
	description = "List of CIDR blocks for DB(isolated) subnets."
	type = "list"
}