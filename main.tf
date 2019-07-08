#-----/main.tf-----

# Configure the AWS Provider
provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  version = "~> 2.18.0"
}

#Configure a VPC

module "networking" {
  source = "./modules/networking"

  vpc_name = "${var.vpc_name}"
  vpc_subnet = "${var.vpc_subnet}"
  vpc_tenancy = "${var.vpc_tenancy}"

  dmz_count = "${var.dmz_count}"
  dmz_subnets = "${var.dmz_subnets}"

  app_count = "${var.app_count}"
  app_subnets = "${var.app_subnets}"

  data_count = "${var.data_count}"
  data_subnets = "${var.data_subnets}"
	
  ssh_access_ips = "${var.ssh_access_ips}"
  web_access_ips = "${var.web_access_ips}"
}

module "database" {
  source = "./modules/database"

  db_subnets = ["${module.networking.data_subnets}"]
  db_name = "${var.db_name}"
  db_username = "${var.db_username}"
  db_password = "${var.db_password}"
  db_instance_class = "${var.db_instance_class}"
  db_size = "${var.db_size}"
  db_sgs = ["${module.networking.db_sg}"]
}

module "efs" {
  source = "./modules/efs"
  efs_performance = "${var.efs_performance}"
  efs_subnets = ["${module.networking.data_subnets}"]
  efs_sgs = ["${module.networking.efs_sg}"]
}

module "alb" {
  source = "./modules/alb"

  alb_sgs = ["${module.networking.alb_sg}"]
  alb_subnets = ["${module.networking.dmz_subnets}"]
  vpc_id = "${module.networking.vpc}"
}

# Specify user_data templates

data "template_file" "bastion_template" {
  template = "${file("bastion_user_data.tpl")}"
}

data "template_file" "web_template" {
  template = "${file("web_user_data.tpl")}"

  vars {
    fs_path = "${module.dns.fs_fqdn}"
    mysql_host = "${module.dns.db_fqdn}"
    mysql_root_password = "${var.db_password}"
    wp_db_username = "${var.db_username}"
    wp_db_name = "${var.db_name}"
    wp_path = "${var.wp_path}"
    wp_domain = "${var.public_domain_name}"
    wp_title = "${var.wp_title}"
    wp_admin_username = "${var.wp_admin_username}"
    wp_admin_email = "${var.wp_admin_email}"
    wp_admin_password = "${var.wp_admin_password}"
  }
}

module "compute" {
  source = "./modules/compute"

  ec2_key_path = "${var.ec2_key_path}"

  bastion_sgs = ["${module.networking.bastion_sg}"]
  bastion_user_data = "${data.template_file.bastion_template.rendered}"
  bastion_asg_subnets = ["${module.networking.dmz_subnets}"]
  bastion_instance_type = "${var.bastion_instance_type}"

  web_instances_min = "${var.web_instances_min}"
  web_instances_max = "${var.web_instances_max}"
  web_sgs = ["${module.networking.web_sg}"]
  web_user_data = "${data.template_file.web_template.rendered}"
  web_asg_subnets = ["${module.networking.app_subnets}"]
  web_instance_type = "${var.web_instance_type}"
  alb_tgs = ["${module.alb.alb_tg}"]
}

module "dns" {
  source = "./modules/dns"

  public_domain_name = "${var.public_domain_name}"
  alb_dns_name = "${module.alb.alb_dns_name}" 
  alb_zone_id = "${module.alb.alb_zone_id}"
  vpc_id = "${module.networking.vpc}"
  fs_endpoint = "${module.efs.efs_dns_name}"
  db_endpoint = "${module.database.rds_instance_hostname}"
}
