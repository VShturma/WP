#-----modules/route53/variables.tf-----

variable "public_domain_name" {
  description = "Domain Name for the public hosted zone. If set to 'false' an ALB's endpoint will be used"
}

variable "alb_dns_name" {
  description = "FQDN of an ALB"
}

variable "alb_zone_id" {
  description = "Zone ID of an ALB"
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

