#-----rds/main.tf-----

resource "aws_db_subnet_group" "default" {
  name        = "wp-subnet-group"
  description = "WordPress DB subnet group"
  subnet_ids  = var.db_subnets

  tags = {
    Name = "wp-subnet-group"
  }
}

resource "aws_db_instance" "default" {
  identifier                = var.db_name
  name                      = var.db_name
  username                  = var.db_username
  password                  = var.db_password
  instance_class            = var.db_instance_class
  allocated_storage         = var.db_size
  vpc_security_group_ids    = var.db_sgs
  engine                    = "mysql"
  storage_type              = "gp2"
  db_subnet_group_name      = aws_db_subnet_group.default.name
  final_snapshot_identifier = "wordpress-final-snapshot-${md5(timestamp())}"

  tags = {
    Name = var.db_name
  }
}

