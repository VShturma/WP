#-----modules/ssm/variables.tf-----

variable "php_version" {
  description = "Specify PHP version of a Web server"
}

variable "fs_path" {
  description = "FQDN of an EFS endpoint"
}

variable "mysql_host" {
  description = "FQDN of an RDS endpoint"
}

variable "mysql_root_password" {
  description = "Database Master Password"
}

variable "wp_db_username" {
  description = "Database Master Username"
}

variable "wp_db_name" {
  description = "Database Name"
}

variable "www_path" {
  description = "Web Server direcory"
}

variable "wp_path" {
  description = "Wordpress Site Directory"
}

variable "wp_domain" {
  description = "Domain Name for the public hosted zone"
}

variable "wp_title" {
  description = "WordPress Title"
}

variable "wp_admin_username" {
  description = "WordPress Administrator Username"
}

variable "wp_admin_password" {
  description = "WordPress Administrator Username Password"
}

variable "wp_admin_email" {
  description = "WordPress Administrator Username Email"
}

variable "instance_name_tag" {
  description = "Specify a name tag used by SSM to filter target instances"
}

variable "repo_source_type" { 
  description = "Repository source type"
}

variable "repo_owner" { 
  description = "Repository owner"
}

variable "repo_name" {
  description = "Name of the repository"
}

variable "repo_path" { 
  description = "Specify the path to a content that is going to be downloaded"
}

variable "repo_branch" { 
  description = "Specify the repository branch"
}

variable "playbook_file" { 
  description = "Name of the playbook file"
}

