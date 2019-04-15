#-----/main.tf-----

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

#Configure a VPC

module "networking" {
  source = "./modules/networking"

  vpc_name = "WP"
  vpc_subnet = "${var.vpc_subnet}"
  vpc_tenancy = "${var.vpc_tenancy}"

  dmz_count = "${var.dmz_count}"
  dmz_subnets = "${var.dmz_subnets}"

  app_count = "${var.app_count}"
  app_subnets = "${var.app_subnets}"

  db_count = "${var.db_count}"
  db_subnets = "${var.db_subnets}"
}
