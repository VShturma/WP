#-----outputs.tf-----

output "public_zone_nameservers" {
  value = module.route53.public_zone_nameservers
}

output "wordpress_fqdn" {
  value = module.ssm.wp_domain
}
