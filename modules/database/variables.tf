#-----/database/variables.tf-----

variable "db_subnets" {
  description = "List of db subnets"
  type = "list"
}

variable "db_name" {
  description = "Database Name"
}

variable "db_username" {
  description = "Database Master Username"
}

variable "db_password" {
  description = "Database Master Password"
}

variable "db_instance_class" {
  description = "Database Instance Class Type"
}

variable "db_size" {
  description = "Database Size"
}

variable "db_sgs" {
	description = "List of secutiry groups to associate with the Database"
	type = "list"
}
