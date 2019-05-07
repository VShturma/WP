#-----/main.tf-----

# Configure the AWS Provider
provider "aws" {
  region = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
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
