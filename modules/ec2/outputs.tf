#-----modules/compute/outputs.tf-----

output "web_asg" {
  value = aws_autoscaling_group.web_asg
}
