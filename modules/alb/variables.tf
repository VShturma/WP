#-----modules/alb/variables.tf-----

variable "alb_sgs" {
  description = "A list of security group IDs to assign to the ALB"
  type        = list(string)
}

variable "alb_subnets" {
  description = "A list of subnet IDs to attach to the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "The identifier of the VPC in which to create the target group"
}

