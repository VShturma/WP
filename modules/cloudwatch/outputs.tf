#-----modules/cloudwatch/outputs.tf-----

output "configure_web_instances_rule" {
  value = aws_cloudwatch_event_rule.configure_web_instances
}
