#-----/networking/outputs.tf-----

output "data_subnets" {
	value = "${aws_subnet.data.*.id}"
}

output "db_sgs" {
	value = "${aws_security_group.db.id}"
}