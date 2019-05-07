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

resource "aws_lb_target_group" "alb_tg_public" {
  name = "PublicAlbTargetGroup"
  port = 80
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"
  
  health_check = {
    path = "/wp-config.php"
    matcher = "200"
  }

  tags {
    Name = "PublicAlbTargetGroup"
  }
}

resource "aws_lb_listener" "front_end_http" {
  load_balancer_arn = "${aws_lb.alb_wp.arn}"
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.alb_tg_public.arn}"
  }
}
