#-----modules/iam/outputs.tf-----

output "ssm_profile" {
  value = aws_iam_instance_profile.ssm_profile
}

output "ssm_instance_role" {
  value = aws_iam_role.ssm_instance_role
}


