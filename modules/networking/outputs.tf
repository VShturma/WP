#-----/networking/outputs.tf-----

output "data_subnets" {
  value = ["${aws_subnet.data.*.id}"]
}

output "db_sg" {
  value = "${aws_security_group.db.id}"
}

output "efs_sgs" {
  value = ["${aws_security_group.efs.id}"]
}

