#-----modules/dns/variables.tf-----

variable "vpc_id" {
  description = "The identifier of the VPC in which to create the target group"
}

variable "fs_endpoint" {
  description = "Elastic File System Endpoint"
}

variable "db_endpoint" {
  description = "Database Endpoint"
}
