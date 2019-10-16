#-----/outputs.tf-----

output "public_zone_nameservers" {
  value = module.dns.public_zone_nameservers
}
