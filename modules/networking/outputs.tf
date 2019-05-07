#-----/networking/outputs.tf-----

output "vpc" {
  value = "${aws_vpc.main.id}"
}

output "dmz_subnets" {
  value = ["${aws_subnet.dmz.*.id}"]
}

output "app_subnets" {
  value = ["${aws_subnet.app.*.id}"]
}

output "data_subnets" {
  value = ["${aws_subnet.data.*.id}"]
}

output "bastion_sg" {
  value = "${aws_security_group.bastion.id}"
}

output "alb_sg" {
  value = "${aws_security_group.alb.id}"
}

output "web_sg" {
  value = "${aws_security_group.web.id}"
}

output "db_sg" {
  value = "${aws_security_group.db.id}"
}

output "efs_sg" {
  value = ["${aws_security_group.efs.id}"]
}


