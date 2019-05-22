#-----modules/compute/variables.tf-----

variable "ec2_key_path" {
  description = "EC2 Key Pair path"
}

variable "bastion_sgs" {
  description = "List of security group IDs to assign to a Bastion host"
  type = "list"
}

variable "bastion_user_data" {
  description = "User data for a Bastion host"
}

variable "bastion_asg_subnets" {
  description = "List of subnets to assign to the Bastion AutoScaling Group"
  type = "list"
}
