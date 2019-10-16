#-----modules/dns/outputs.tf-----

output "fs_fqdn" {
  value = aws_route53_record.fs.fqdn
}

output "db_fqdn" {
  value = aws_route53_record.db.fqdn
}

output "public_zone_nameservers" {
  value = aws_route53_zone.public.name_servers
}
