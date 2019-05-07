#-----/networking/outputs.tf-----

output "dmz_subnets" {
  value = ["${aws_subnet.dmz.*.id}"]
}

output "app_subnets" {
  value = ["${aws_subnet.app.*.id}"]
}

output "data_subnets" {
  value = ["${aws_subnet.data.*.id}"]
}

output "db_sgs" {
  value = "${aws_security_group.db.id}"
}

output "efs_sg" {
  value = "${aws_security_group.efs.id}"
}


