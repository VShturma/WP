#-----modules/dns/variables.tf-----

variable "public_domain_name" {
  description = "Domain Name for the public hosted zone"
}

variable "vpc_id" {
  description = "The identifier of the VPC in which to create the target group"
}

variable "fs_endpoint" {
  description = "Elastic File System Endpoint"
}

variable "db_endpoint" {
  description = "Database Endpoint"
}
