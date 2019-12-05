#-----modules/compute/variables.tf-----

variable "ec2_key_path" {
  description = "EC2 Key Pair path"
}

variable "bastion_sgs" {
  description = "List of security group IDs to assign to a Bastion host"
  type        = list(string)
}

variable "bastion_instance_type" {
  description = "Bastion Instance Type"
}

variable "bastion_user_data" {
  description = "User data for a Bastion host"
}

variable "bastion_asg_subnets" {
  description = "List of subnets to assign to the Bastion AutoScaling Group"
  type        = list(string)
}

variable "web_instance_type" {
  description = "Web Instance Type"
}

variable "web_instance_profile" {
  description = "IAM Instance Profile for web instances"
}

variable "web_sgs" {
  description = "List of security group IDs to assign to a Web instance"
  type        = list(string)
}

variable "web_user_data" {
  description = "User data for a Web instance"
}

variable "web_instances_min" {
  description = "The minimum (and desired) number of instances in the web tier auto scaling group"
}

variable "web_instances_max" {
  description = "The maximum number of instances in the web tier auto scaling group"
}

variable "web_instances_desired" {
  description = "The number of desired instances in the web tier auto scaling group"
}

variable "web_asg_subnets" {
  description = "List of subnets to assign to the Web AutoScaling Group"
  type        = list(string)
}

variable "alb_tgs" {
  description = "A list of target group ARNs, for use with Application Load Balancer"
  type        = list(string)
}

