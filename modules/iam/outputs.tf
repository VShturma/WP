#-----modules/iam/outputs.tf-----

output "ssm_profile" {
  value = aws_iam_instance_profile.ssm_profile
}
