#-----/networking/main.tf-----

# VPC
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_subnet}"
  enable_dns_hostnames = true
  instance_tenancy = "${var.vpc_tenancy}"
  
  tags = {
    Name = "${var.vpc_name}"
  }
}

data "aws_availability_zones" "available" {}

# DMZ(public) subnets
resource "aws_subnet" "DMZ" {
	count = "${var.dmz_count}"
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.dmz_subnets.[count.index]}"
	availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
	map_public_ip_on_launch = true

	tags = {
		Name = "DMZpublic${count.index + 1}"
	}
}

# APP(private) subnets
resource "aws_subnet" "APP" {
	count = "${var.app_count}"
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.app_subnets.[count.index]}"
	availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

	tags = {
		Name = "APPprivate${count.index + 1}"
	}
}

# DB(isolated) subnets
resource "aws_subnet" "DB" {
	count = "${var.db_count}"
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.db_subnets.[count.index]}"
	availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

	tags = {
		Name = "DBisolated${count.index + 1}"
	}
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
	vpc_id = "${aws_vpc.main.id}"

	tags = {
		Name = "IGW"
	}
}

# NAT Gateway
resource "aws_eip" "nat" {}

resource "aws_nat_gateway" "ngw" {
	allocation_id = "${aws_eip.nat.id}"
	subnet_id = "${aws_subnet.DMZ.0.id}"

	tags = {
		Name = "NGW"
	}
}

# Routing for DMZ(public) subnets
resource "aws_route_table" "public" {
	vpc_id = "${aws_vpc.main.id}"

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.igw.id}"
	}

	tags = {
		Name = "publicRT"
	}
}

resource "aws_route_table_association" "public" {
	count = "${aws_subnet.DMZ.count}"
	subnet_id = "${aws_subnet.DMZ.*.id[count.index]}"
	route_table_id = "${aws_route_table.public.id}"
}

# Routing for APP(private) subnets
resource "aws_route_table" "private" {
	vpc_id = "${aws_vpc.main.id}"

	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = "${aws_nat_gateway.ngw.id}"
	}

	tags = {
		Name = "privateRT"
	}
}

resource "aws_route_table_association" "private" {
	count = "${aws_subnet.APP.count}"
	subnet_id = "${aws_subnet.APP.*.id[count.index]}"
	route_table_id = "${aws_route_table.private.id}"
}

# Routing for DB(isolated) subnets
resource "aws_route_table" "isolated" {
	vpc_id = "${aws_vpc.main.id}"

	tags = {
		Name = "isolatedRT"
	}
}

resource "aws_route_table_association" "isolated" {
	count = "${aws_subnet.DB.count}"
	subnet_id = "${aws_subnet.DB.*.id[count.index]}"
	route_table_id = "${aws_route_table.isolated.id}"
}


