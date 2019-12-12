#-----modules/route53/main.tf-----

#################################
# Configure a public Hosted Zone
#################################

resource "aws_route53_zone" "public" {

  count = var.public_domain_name ? 1 : 0  

  name    = var.public_domain_name
  comment = "Public hosted zone for a WordPress environment"
}

resource "aws_route53_record" "www" {

  count = var.public_domain_name ? 1 : 0
  
  zone_id = aws_route53_zone.public[count.index].zone_id
  name    = var.public_domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}

##################################
# Configure a private Hosted Zone
##################################

resource "aws_route53_zone" "private" {
  name    = "wp.local"
  comment = "Private hosted zone for a WordPress environment"

  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "fs" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "fs.wp.local"
  type    = "CNAME"
  ttl     = "300"
  records = [var.fs_endpoint]
}

resource "aws_route53_record" "db" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "db.wp.local"
  type    = "CNAME"
  ttl     = "300"
  records = [var.db_endpoint]
}

