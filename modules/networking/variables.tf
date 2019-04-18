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

variable "data_count" {
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

variable "data_subnets" {
	description = "List of CIDR blocks for DB(isolated) subnets."
	type = "list"
}

variable "ssh_access_ips" {
	description = "List of IPs that can SSH to a Bastion host."
	type = "list"
}

variable "web_access_ips" {
	description = "List of IPs that can acess web resources via HTTP/HTTPS."
	type = "list"
}