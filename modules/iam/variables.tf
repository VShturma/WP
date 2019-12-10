#-----modules/iam/variables.tf-----

variable "aws_region" {
  description = "Target AWS region"
}

variable "web_instance_name_tag" {
  description = "Specify a name tag that should be assigned to Web instances"
}
