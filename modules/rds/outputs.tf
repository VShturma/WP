#-----rds/outputs.tf-----

output "rds_instance_hostname" {
  value = aws_db_instance.default.address
}

