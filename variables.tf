#-----variables.tf-----

#############################
# Configure the AWS Provider
#############################

variable "aws_region" {
  description = "The region where the environment is going to be provisioned"
}

#################
#Configure a VPC
#################

variable "vpc_name" {
  description = "Name of a new VPC"
  default     = "WP"
}

variable "vpc_ipv4_cidr" {
  description = "CIDR block for a new VPC"
  default     = "10.100.0.0/16"
}

variable "vpc_tenancy" {
  description = "VPC tenancy value (default or dedicated)"
  default     = "default"
}

variable "az_count" {
  description = "Number of Availability Zones to provision to"
  default     = 2
}

variable "dmz_subnets" {
  description = "List of CIDR blocks for DMZ(public) subnets."
  type        = list(string)
  default     = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24", "10.100.4.0/24", "10.100.5.0/24", "10.100.6.0/24"]
}

variable "app_subnets" {
  description = "List of CIDR blocks for APP(private) subnets."
  type        = list(string)
  default     = ["10.100.11.0/24", "10.100.12.0/24", "10.100.13.0/24", "10.100.14.0/24", "10.100.15.0/24", "10.100.16.0/24"]
}

variable "data_subnets" {
  description = "List of CIDR blocks for Data(isolated) subnets."
  type        = list(string)
  default     = ["10.100.21.0/24", "10.100.22.0/24", "10.100.23.0/24", "10.100.24.0/24", "10.100.25.0/24", "10.100.26.0/24"]
}

variable "nat_gw_per_az" {
  description = "If set to 'true' a NAT gateway will be provisioned for every AZ involved in the app"
  default     = true
}

variable "ssh_access_ips" {
  description = "List of IPs that can SSH to a Bastion host"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "web_access_ips" {
  description = "List of IPs that can acess web resources via HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

##################################
# Configure an RDS-based database
##################################

variable "db_name" {
  description = "Database Name"
}

variable "db_username" {
  description = "Database Master Username"
}

variable "db_password" {
  description = "Database Master Password"
}

variable "db_instance_class" {
  description = "Database Instance Class Type"
  default     = "db.t2.micro"
}

variable "db_size" {
  description = "Database Size"
  default     = 20
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  default = true
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  default = false
}

#########################
# Configure an EFS share
#########################

variable "efs_performance" {
  description = "The EFS filesystem performance mode. Can be generalPurpose or maxIO"
  default     = "generalPurpose"
}

###########################
# Configure SSM parametres
###########################

variable "php_version" {
  description = "Specify PHP version of a Web server"
  default = "7.2"
}

variable "www_path" {
  description = "Web Server direcory"
  default = "/var/www"
}

variable "wp_path" {
  description = "Wordpress Site Directory"
  default     = "/var/www/html"
}

variable "public_domain_name" {
  description = "Domain Name for the public hosted zone"
  default     = "test.tk"
}

variable "wp_title" {
  description = "WordPress Title"
  default     = "WordPress Test Page"
}

variable "wp_admin_username" {
  description = "WordPress Administrator Username"
  default     = "Admin"
}

variable "wp_admin_password" {
  description = "WordPress Administrator Username Password"
  default     = "P@s$w0rd"
}

variable "wp_admin_email" {
  description = "WordPress Administrator Username Email"
  default     = "test@example.com"
}

##########################
# Configure EC2 instances
##########################

variable "ec2_key_path" {
  description = "EC2 Key Pair path"
  default     = "ec2_key.pub"
}

variable "bastion_instances_min" {
  description = "The minimum number of instances in the bastion auto scaling group"
  default     = 0
}

variable "bastion_instances_max" {
  description = "The maximum number of instances in the bastion auto scaling group"
  default     = 1
}

variable "bastion_instances_desired" {
  description = "The number of desired instances in the bastion auto scaling group"
  default = 0
}


variable "bastion_instance_type" {
  description = "Bastion Instance Type"
  default     = "t2.micro"
}

variable "bastion_instance_name_tag" {
  description = "Specify a name tag that should be assigned to Bastion instances"
  default = "Bastion"
}

variable "web_instance_type" {
  description = "Web Instance Type"
  default     = "t2.micro"
}

variable "web_instances_min" {
  description = "The minimum number of instances in the web tier auto scaling group"
  default     = 0
}

variable "web_instances_desired" {
  description = "The number of desired instances in the web tier auto scaling group"
  default = 2
}

variable "web_instance_name_tag" {
  description = "Specify a name tag that should be assigned to Web instances"
  default = "Web"
}
