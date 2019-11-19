#-----variables.tf-----

#############################
# Configure the AWS Provider
#############################

variable "aws_region" {
  default = "eu-central-1"
}

#################
#Configure a VPC
#################

variable "vpc_name" {
  description = "Name of a new VPC."
  default     = "WP"
}

variable "vpc_subnet" {
  description = "CIDR block for a new VPC."
  default     = "10.100.0.0/16"
}

variable "vpc_tenancy" {
  description = "VPC tenancy value (default or dedicated)."
  default     = "default"
}

variable "dmz_count" {
  description = "Number of DMZ subnets."
  default     = 2
}

variable "app_count" {
  description = "Number of APP subnets."
  default     = 2
}

variable "data_count" {
  description = "Number of DB subnets."
  default     = 2
}

variable "dmz_subnets" {
  description = "List of CIDR blocks for DMZ(public) subnets."
  type        = list(string)
  default     = ["10.100.1.0/24", "10.100.2.0/24"]
}

variable "app_subnets" {
  description = "List of CIDR blocks for APP(private) subnets."
  type        = list(string)
  default     = ["10.100.11.0/24", "10.100.12.0/24"]
}

variable "data_subnets" {
  description = "List of CIDR blocks for Data(isolated) subnets."
  type        = list(string)
  default     = ["10.100.21.0/24", "10.100.22.0/24"]
}

variable "ssh_access_ips" {
  description = "List of IPs that can SSH to a Bastion host."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "web_access_ips" {
  description = "List of IPs that can acess web resources via HTTP/HTTPS."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "nat_gw_per_az" {
  description = "If set to 'true' a NAT gateway will be provisioned for every AZ involved in the app."
  default     = true
}

##################################
# Configure an RDS-based database
##################################

variable "db_name" {
  description = "Database Name"
  default     = "wordpress"
}

variable "db_username" {
  description = "Database Master Username"
  default     = "root"
}

variable "db_password" {
  description = "Database Master Password"
  default     = "P@s$w0rd"
}

variable "db_instance_class" {
  description = "Database Instance Class Type"
  default     = "db.t2.micro"
}

variable "db_size" {
  description = "Database Size"
  default     = 20
}

#########################
# Configure an EFS share
#########################

variable "efs_performance" {
  description = "The EFS filesystem performance mode. Can be generalPurpose or maxIO"
  default     = "generalPurpose"
}

##############################
# Specify User Data templates
##############################

variable "public_domain_name" {
  description = "Domain Name for the public hosted zone"
  default     = "test.tk"
}

variable "wp_path" {
  description = "Wordpress Site Directory"
  default     = "/var/www/html"
}

variable "wp_title" {
  description = "WordPress Title"
  default     = "WordPress Test Page"
}

variable "wp_admin_username" {
  description = "WordPress Administrator Username"
  default     = "Admin"
}

variable "wp_admin_email" {
  description = "WordPress Administrator Username Email"
  default     = "test@example.com"
}

variable "wp_admin_password" {
  description = "WordPress Administrator Username Password"
  default     = "P@s$w0rd"
}

##########################
# Configure EC2 instances
##########################

variable "ec2_key_path" {
  description = "EC2 Key Pair path"
  default     = "ec2_key.pub"
}

variable "bastion_instance_type" {
  description = "Bastion Instance Type"
  default     = "t2.micro"
}

variable "web_instance_type" {
  description = "Web Instance Type"
  default     = "t2.micro"
}

variable "web_instances_min" {
  description = "The minimum (and desired) number of instances in the web tier auto scaling group"
  default     = 0
}

variable "web_instances_max" {
  description = "The maximum number of instances in the web tier auto scaling group"
  default     = 2
}


