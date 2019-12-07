#-----modules/cloudwatch/variables.tf-----

variable "asg_name" {
  description = "AutoScaling Group name"
}

variable "aws_region" {
  description = "Target AWS region"
}

variable "ssm_role" {
  description = "IAM role for executing SSM run command"
}

variable "web_instance_name_tag" {
  description = "Specify a name tag that should be assigned to Web instances"
}

