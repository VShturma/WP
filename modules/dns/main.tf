#-----modules/dns/main.tf-----

resource "aws_route53_zone" "private" {
  name = "wp.local"
  comment = "Private hosted zone for a WordPress environment"
  
  vpc {
    vpc_id = "${var.vpc_id}"
  }
}
