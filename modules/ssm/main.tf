#-----modules/ssm/main.tf-----

resource "aws_ssm_parameter" "php_version" {
  name = "php_version"
  type = "String"
  value = var.php_version
}

resource "aws_ssm_parameter" "fs_path" {
  name = "fs_path"
  type = "String"
  value = var.fs_path
}

resource "aws_ssm_parameter" "mysql_host" {
  name = "mysql_host"
  type = "String"
  value = var.mysql_host
}

resource "aws_ssm_parameter" "mysql_root_password" {
  name = "mysql_root_password"
  type = "SecureString"
  value = var.mysql_root_password
}

resource "aws_ssm_parameter" "wp_db_username" {
  name = "wp_db_username"
  type = "SecureString"
  value = var.wp_db_username
}

resource "aws_ssm_parameter" "wp_db_name" {
  name = "wp_db_name"
  type = "SecureString"
  value = var.wp_db_name
}

resource "aws_ssm_parameter" "www_path" {
  name = "www_path"
  type = "String"
  value = var.www_path
}

resource "aws_ssm_parameter" "wp_path" {
  name = "wp_path"
  type = "String"
  value = var.wp_path
}

resource "aws_ssm_parameter" "wp_domain" {
  name = "wp_domain"
  type = "String"
  value = var.wp_domain    
}

resource "aws_ssm_parameter" "wp_title" {
  name = "wp_title"
  type = "String"
  value = var.wp_title 
}

resource "aws_ssm_parameter" "wp_admin_username" {
  name = "wp_admin_username"
  type = "SecureString"
  value = var.wp_admin_username
}

resource "aws_ssm_parameter" "wp_admin_password" {
  name = "wp_admin_password"
  type = "SecureString"
  value = var.wp_admin_password
}

resource "aws_ssm_parameter" "wp_admin_email" {
  name = "wp_admin_email"
  type = "SecureString"
  value = var.wp_admin_email
}

