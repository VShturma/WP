#-----modules/efs/outputs.tf-----

output "efs_dns_name" {
  value = aws_efs_file_system.wp_efs.dns_name
}

