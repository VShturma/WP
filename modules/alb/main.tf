#-----modules/alb/main.tf-----

resource "aws_lb" "alb_wp" {
  name = "ALB-WP"
  internal = false
  load_balancer_type = "application"
  security_groups = "${var.alb_sgs}"
  subnets = "${var.alb_subnets}"
  ip_address_type = "ipv4"

  tags = {
    Name = "ALB-WP"
  }
}
