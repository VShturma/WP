#-----modules/alb/variables.tf-----

variable "alb_sgs" {
  description = "A list of security group IDs to assign to the ALB"
  type = "list"
}

variable "alb_subnets" {
  description = "A list of subnet IDs to attach to the ALB"
  type = "list"
}
