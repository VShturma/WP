#-----modules/vpc/variables.tf-----

variable "vpc_name" {
  description = "Name of a new VPC"
}

variable "vpc_ipv4_cidr" {
  description = "CIDR block for a new VPC"
}

variable "vpc_tenancy" {
  description = "VPC tenancy value (default or dedicated)"
}

variable "az_count" {
  description = "Number of Availability Zones to provision to"
}

variable "dmz_subnets" {
  description = "List of CIDR blocks for DMZ(public) subnets"
  type        = list(string)
}

variable "app_subnets" {
  description = "List of CIDR blocks for APP(private) subnets"
  type        = list(string)
}

variable "data_subnets" {
  description = "List of CIDR blocks for DB(isolated) subnets"
  type        = list(string)
}

variable "nat_gw_count" {
  description = "The number of NAT gateways to provision"
}

variable "ssh_access_ips" {
  description = "List of IPs that can SSH to a Bastion host"
  type        = list(string)
}

variable "web_access_ips" {
  description = "List of IPs that can acess web resources via HTTP"
  type        = list(string)
}

