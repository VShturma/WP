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
