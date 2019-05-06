#-----modules/efs/variables.tf-----

variable "efs_performance" {
  description = "The EFS filesystem performance mode. Can be generalPurpose or maxIO"
}

variable "efs_subnets" {
  description = "List of data subnets"
  type = "list"
}
