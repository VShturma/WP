#-----main.tf-----

#############################
# Configure the AWS Provider
#############################

provider "aws" {
  region     = var.aws_region
  version    = "~> 2.18.0"
}

#################
#Configure a VPC
#################

module "vpc" {
  source = "./modules/vpc"

  vpc_name    = var.vpc_name
  vpc_ipv4_cidr  = var.vpc_ipv4_cidr
  vpc_tenancy = var.vpc_tenancy

  az_count = var.az_count

  dmz_subnets = var.dmz_subnets
  app_subnets = var.app_subnets
  data_subnets = var.data_subnets

# If nat_gw_per_az is 'true'(default) a NAT gateway will be created for every AZ. Otherwise, there will be only 1 NAT gateway per region
  nat_gw_count = var.nat_gw_per_az ? var.az_count : 1

  ssh_access_ips = var.ssh_access_ips
  web_access_ips = var.web_access_ips
 }

##################################
# Configure an RDS-based database
##################################

module "rds" {
  source = "./modules/rds"

  db_subnets        = module.vpc.data_subnets
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_instance_class = var.db_instance_class
  db_size           = var.db_size
  db_sgs            = [module.vpc.db_sg]
  multi_az          = var.multi_az
  skip_final_snapshot    = var.skip_final_snapshot
}

#########################
# Configure an EFS share
#########################

module "efs" {
  source          = "./modules/efs"
  efs_performance = var.efs_performance
  efs_subnets     = module.vpc.data_subnets
  efs_sgs         = [module.vpc.efs_sg]
}

##############################
# Configure SSM parametres
##############################

module "ssm" {
  source = "./modules/ssm"

  php_version = var.php_version
  fs_path             = module.dns.fs_fqdn
  mysql_host          = module.dns.db_fqdn
  mysql_root_password = var.db_password
  wp_db_username      = var.db_username
  wp_db_name          = var.db_name
  www_path = var.www_path
  wp_path             = var.wp_path
  wp_domain           = var.public_domain_name
  wp_title            = var.wp_title
  wp_admin_username   = var.wp_admin_username
  wp_admin_password   = var.wp_admin_password
  wp_admin_email      = var.wp_admin_email
}

#################################
# Configure IAM instance profile
#################################

module "iam" {
  source = "./modules/iam"

  aws_region = var.aws_region 
  web_instance_name_tag = var.web_instance_name_tag
}

##################################
# Configure EC2 instances and ALB
##################################

module "ec2" {
  source = "./modules/ec2"

  alb_sgs     = [module.vpc.alb_sg]
  alb_subnets = module.vpc.dmz_subnets
  vpc_id      = module.vpc.vpc

  ec2_key_path = var.ec2_key_path
  
  bastion_instances_min = var.bastion_instances_min
  bastion_instances_max = var.bastion_instances_max
  bastion_instances_desired = var.bastion_instances_desired
  bastion_sgs           = [module.vpc.bastion_sg]
  bastion_asg_subnets   = module.vpc.dmz_subnets
  bastion_instance_type = var.bastion_instance_type
  bastion_instance_name_tag = var.bastion_instance_name_tag
  web_instances_min = var.web_instances_min
  web_instances_max = var.az_count
  web_instances_desired = var.web_instances_desired
  web_sgs           = [module.vpc.web_sg]
  web_asg_subnets   = module.vpc.app_subnets
  web_instance_type = var.web_instance_type
  web_instance_profile = module.iam.ssm_profile.name
  web_instance_name_tag = var.web_instance_name_tag
}

#################################
# Configure Route53 Hosted Zones
#################################

module "dns" {
  source = "./modules/dns"

  public_domain_name = var.public_domain_name
  alb_dns_name       = module.ec2.alb_dns_name
  alb_zone_id        = module.ec2.alb_zone_id
  vpc_id             = module.vpc.vpc
  fs_endpoint        = module.efs.efs_dns_name
  db_endpoint        = module.rds.rds_instance_hostname
}

