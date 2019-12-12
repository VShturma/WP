#-----modules/ec2/outputs.tf-----

output "alb_dns_name" {
  value = aws_lb.alb_wp.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb_wp.zone_id
}

output "alb_tg" {
  value = aws_lb_target_group.alb_tg_public.arn
}

output "web_asg" {
  value = aws_autoscaling_group.web_asg
}
