#-----modules/cloudwatch/main.tf-----

resource "aws_cloudwatch_event_rule" "configure_web_instances" {
  name = "Configure-Web-Instances"
  role_arn = var.ssm_role
  event_pattern = <<PATTERN
{
  "source": [
    "aws.autoscaling"
  ],
  "detail-type": [
    "EC2 Instance Launch Successful"
  ],
  "detail": {
    "AutoScalingGroupName": [
      "${var.asg_name}"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "run_ssm_command" {
  rule = aws_cloudwatch_event_rule.configure_web_instances.name
  arn = "arn:aws:ssm:${var.aws_region}::document/AWS-ApplyAnsiblePlaybooks"
  role_arn = var.ssm_role
  input = <<EOF
{
  "SourceType": ["GitHub"],
  "SourceInfo": ["{\"owner\":\"VShturma\",\"repository\":\"WP\",\"path\":\"automation/playbook.yml\",\"getOptions\":\"branch:playbooks\"}"],
  "InstallDependencies": ["True"],
  "PlaybookFile": ["playbook.yml"],
  "ExtraVariables": ["SSM=True"],
  "Check": ["False"],
  "Verbose": ["-v"]
}
EOF

  run_command_targets {
    key = "tag:Name"
    values = [var.web_instance_name_tag]
  }
}
