#-----modules/dns/main.tf-----

resource "aws_route53_zone" "private" {
  name = "wp.local"
  comment = "Private hosted zone for a WordPress environment"
  
  vpc {
    vpc_id = "${var.vpc_id}"
  }
}

resource "aws_route53_record" "fs" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name = "fs.wp.local"
  type = "CNAME"
  ttl = "300"
  records = ["${var.fs_endpoint}"]
}

resource "aws_route53_record" "db" { 
  zone_id = "${aws_route53_zone.private.zone_id}"
  name = "db.wp.local"
  type = "CNAME"
  ttl = "300"
  records = ["${var.db_endpoint}"]
}
