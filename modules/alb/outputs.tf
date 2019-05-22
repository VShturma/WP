#-----modules/alb/outputs.tf-----

output "alb_tg" {
  value = "${aws_lb_target_group.alb_tg_public.arn}"
}
