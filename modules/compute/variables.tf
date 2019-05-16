#-----modules/compute/variables.tf-----

variable "ec2_key_path" {
  description = "EC2 Key Pair path"
}

variable "bastion_sgs" {
  description = "A list of security group IDs to assign to a Bastion host"
  type = "list"
}

variable "bastion_user_data" {
  description = "User data for a Bastion host"
}
