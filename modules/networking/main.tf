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
resource "aws_subnet" "dmz" {
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
resource "aws_subnet" "app" {
	count = "${var.app_count}"
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.app_subnets.[count.index]}"
	availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

	tags = {
		Name = "APPprivate${count.index + 1}"
	}
}

# Data(isolated) subnets
resource "aws_subnet" "data" {
	count = "${var.data_count}"
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.data_subnets.[count.index]}"
	availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

	tags = {
		Name = "DATAisolated${count.index + 1}"
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
#resource "aws_eip" "nat" {}

#resource "aws_nat_gateway" "ngw" {
#	allocation_id = "${aws_eip.nat.id}"
#	subnet_id = "${aws_subnet.dmz.0.id}"	#requires an improvment.
#
#	tags = {
#		Name = "NGW"
#	}
#}

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
	count = "${aws_subnet.dmz.count}"
	subnet_id = "${aws_subnet.dmz.*.id[count.index]}"
	route_table_id = "${aws_route_table.public.id}"
}

# Routing for APP(private) subnets
resource "aws_route_table" "private" {
	vpc_id = "${aws_vpc.main.id}"

#	route {
#		cidr_block = "0.0.0.0/0"
#		nat_gateway_id = "${aws_nat_gateway.ngw.id}"
#	}

	tags = {
		Name = "privateRT"
	}
}

resource "aws_route_table_association" "private" {
	count = "${aws_subnet.app.count}"
	subnet_id = "${aws_subnet.app.*.id[count.index]}"
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
	count = "${aws_subnet.data.count}"
	subnet_id = "${aws_subnet.data.*.id[count.index]}"
	route_table_id = "${aws_route_table.isolated.id}"
}

# Security Groups
# Egress rules are configured separately in order to avoid https://github.com/terraform-providers/terraform-provider-aws/issues/6015
# HTTP/HTTPS egress rules are configured for both bastion and web SGs in one block.

## Bastion SG
resource "aws_security_group" "bastion" {
	name = "BastionSecurityGroup"
	description = "Security group for Bastion instances"
	vpc_id = "${aws_vpc.main.id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = "${var.ssh_access_ips}"
	}

	tags = {
		Name = "BastionSecurityGroup"
	}
}

resource "aws_security_group_rule" "allow_egress_ssh" {
	type = "egress"
	from_port = 22
	to_port = 22
	protocol = "tcp"
	source_security_group_id = "${aws_security_group.web.id}"
	security_group_id = "${aws_security_group.bastion.id}"
}

## ALB SG
resource "aws_security_group" "alb" {
	name = "PublicAlbSecurityGroup"
	description = "Security group for ALB"
	vpc_id = "${aws_vpc.main.id}"

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = "${var.web_access_ips}"
	}

	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = "${var.web_access_ips}"
	}

	tags = {
		Name = "PublicAlbSecurityGroup"
	}
}

resource "aws_security_group_rule" "allow_egress_http_web" {
	type = "egress"
	from_port = 80
	to_port = 80
	protocol = "tcp"
	source_security_group_id = "${aws_security_group.web.id}"
	security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "allow_egress_https_web" {
	type = "egress"
	from_port = 443
	to_port = 443
	protocol = "tcp"
	source_security_group_id = "${aws_security_group.web.id}"
	security_group_id = "${aws_security_group.alb.id}"
}

## WEB SG
resource "aws_security_group" "web" {
	name = "WebSecurityGroup"
	description = "Security group for web instances"
	vpc_id = "${aws_vpc.main.id}"

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		security_groups = ["${aws_security_group.alb.id}"]
	}

	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		security_groups = ["${aws_security_group.alb.id}"]
	}

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		security_groups = ["${aws_security_group.bastion.id}"]
	}

	tags {
		Name = "WebSecurityGroup"
	}
}

resource "aws_security_group_rule" "allow_egress_http_all" {
	type = "egress"
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.bastion.id}" 
	security_group_id = "${aws_security_group.web.id}"
}

resource "aws_security_group_rule" "allow_egress_https_all" {
	type = "egress"
	from_port = 443
	to_port = 443
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = "${aws_security_group.bastion.id}"
	security_group_id = "${aws_security_group.web.id}"
}

resource "aws_security_group_rule" "allow_egress_efs" {
	type = "egress"
	from_port = 2049
	to_port = 2049
	protocol = "tcp"
	source_security_group_id = "${aws_security_group.efs.id}"
	security_group_id = "${aws_security_group.web.id}"
}

resource "aws_security_group_rule" "allow_egress_db" {
	type = "egress"
	from_port = 3306
	to_port = 3306
	protocol = "tcp"
	source_security_group_id = "${aws_security_group.db.id}"
	security_group_id = "${aws_security_group.web.id}"
}


##DB SG
resource "aws_security_group" "db" {
	name = "DatabaseSecurityGroup"
	description = "Security group for Amazon RDS cluster"
	vpc_id = "${aws_vpc.main.id}"

	ingress {
		from_port = 3306
		to_port = 3306
		protocol = "tcp"
		security_groups = ["${aws_security_group.web.id}"]
	}

	tags = {
		Name = "DatabaseSecurityGroup"
	}
}

## EFS SG
resource "aws_security_group" "efs" {
	name = "EfsSecurityGroup"
	description = "Security group for EFS mount targets"
	vpc_id = "${aws_vpc.main.id}"

	ingress {
		from_port = 2049
		to_port = 2049
		protocol = "tcp"
		security_groups = ["${aws_security_group.web.id}"]
	}

	tags {
		Name = "EfsSecurityGroup"
	}
}

# Network ACLs
## DMZ NACL
resource "aws_network_acl" "dmz" {
	vpc_id = "${aws_vpc.main.id}"
	subnet_ids = ["${aws_subnet.dmz.*.id}"]

	ingress {
		from_port = 80
		to_port = 80
		rule_no = 100
		action = "allow"
		protocol = "tcp"
		cidr_block = "0.0.0.0/0"
	}

	ingress {
		from_port = 443
		to_port = 443
		rule_no = 110
		action = "allow"
		protocol = "tcp"
		cidr_block = "0.0.0.0/0"
	}

	ingress {
		from_port = 1024
		to_port = 65535
		rule_no = 120
		action = "allow"
		protocol = "tcp"
		cidr_block = "0.0.0.0/0"
	}

	egress {
		from_port = 22
		to_port = 22
		rule_no = 100
		action = "allow"
		protocol = "tcp"
		cidr_block = "${var.vpc_subnet}"
	}

	egress {
		from_port = 80
		to_port = 80
		rule_no = 110
		action = "allow"
		protocol = "tcp"
		cidr_block = "0.0.0.0/0"
	}

	egress {
		from_port = 443
		to_port = 443
		rule_no = 120
		action = "allow"
		protocol = "tcp"
		cidr_block = "0.0.0.0/0"
	}

	egress {
		from_port = 32768
		to_port = 65535
		rule_no = 130
		action = "allow"
		protocol = "tcp"
		cidr_block = "0.0.0.0/0"
	}

	tags {
		Name = "DMZ"
	}
}

resource "aws_network_acl_rule" "naclr_dmz_ssh_allow" {
		count = "${length(var.ssh_access_ips)}"
		network_acl_id = "${aws_network_acl.dmz.id}"
		rule_number = "${50 + count.index}"
		protocol = "tcp"
		rule_action = "allow"
		cidr_block = "${element(var.ssh_access_ips, count.index)}"
		from_port = 22
		to_port = 22
}

## APP NACL
resource "aws_network_acl" "app" {
	vpc_id = "${aws_vpc.main.id}"
	subnet_ids = ["${aws_subnet.app.*.id}"]

	ingress {
		from_port = 80
		to_port = 80
		rule_no = 100
		action = "allow"
		protocol = "tcp"
		cidr_block = "${var.vpc_subnet}"
	}

	ingress {
		from_port = 443
		to_port = 443
		rule_no = 110
		action = "allow"
		protocol = "tcp"
		cidr_block = "${var.vpc_subnet}"
	}

	ingress {
		from_port = 22
		to_port = 22
		rule_no = 120
		action = "allow"
		protocol = "tcp"
		cidr_block = "${var.vpc_subnet}"
	}

	ingress {
		from_port = 1024
		to_port = 65535
		rule_no = 130
		action = "allow"
		protocol = "tcp"
		cidr_block = "0.0.0.0/0"
	}

	egress {
		from_port = 80
		to_port = 80
		rule_no = 100
		action = "allow"
		protocol = "tcp"
		cidr_block = "0.0.0.0/0"
	}

	egress {
		from_port = 443
		to_port = 443
		rule_no = 110
		action = "allow"
		protocol = "tcp"
		cidr_block = "0.0.0.0/0"
	}

	egress {
		from_port = 3306
		to_port = 3306
		rule_no = 120
		action = "allow"
		protocol = "tcp"
		cidr_block = "${var.vpc_subnet}"
	}

	egress {
		from_port = 2049
		to_port = 2049
		rule_no = 130
		action = "allow"
		protocol = "tcp"
		cidr_block = "${var.vpc_subnet}"
	}

	egress {
		from_port = 1024
		to_port = 65535
		rule_no = 140
		action = "allow"
		protocol = "tcp"
		cidr_block = "0.0.0.0/0"
	}

	tags {
		Name = "APP"
	}
}

## DB NACL
resource "aws_network_acl" "db" {
	vpc_id = "${aws_vpc.main.id}"
	subnet_ids = ["${aws_subnet.data.*.id}"]

	ingress {
		from_port = 3306
		to_port = 3306
		rule_no = 100
		action = "allow"
		protocol = "tcp"
		cidr_block = "${var.vpc_subnet}"
	}

	ingress {
		from_port = 2049
		to_port = 2049
		rule_no = 110
		action = "allow"
		protocol = "tcp"
		cidr_block = "${var.vpc_subnet}"
	}

	egress {
		from_port = 1024
		to_port = 65535
		rule_no = 100
		action = "allow"
		protocol = "tcp"
		cidr_block = "${var.vpc_subnet}"
	}

	tags {
		Name = "DB"
	}
}
