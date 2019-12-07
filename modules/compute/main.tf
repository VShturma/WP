#-----modules/compute/main.tf-----

data "aws_ami" "amzn_linux2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.????????-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2_key_pair"
  public_key = file(var.ec2_key_path)
}

resource "aws_launch_configuration" "bastion_lc" {
  name                        = "bastion_lc"
  image_id                    = data.aws_ami.amzn_linux2.id
  instance_type               = var.bastion_instance_type
  key_name                    = aws_key_pair.ec2_key_pair.key_name
  security_groups             = var.bastion_sgs
  associate_public_ip_address = true
  enable_monitoring           = false
  ebs_optimized               = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion_asg" {
  name                 = "bastion_asg"
  launch_configuration = aws_launch_configuration.bastion_lc.name
  min_size             = 0
  max_size             = 1
  desired_capacity     = 0
  health_check_type    = "EC2"
  vpc_zone_identifier  = var.bastion_asg_subnets

  tag {
    key = "Name"
    value = var.bastion_instance_name_tag
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "web_lc" {
  name                        = "web_lc"
  image_id                    = data.aws_ami.amzn_linux2.id
  instance_type               = var.web_instance_type
  iam_instance_profile        = var.web_instance_profile
  key_name                    = aws_key_pair.ec2_key_pair.key_name
  security_groups             = var.web_sgs
  associate_public_ip_address = true
  enable_monitoring           = false
  ebs_optimized               = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                 = "web_asg"
  launch_configuration = aws_launch_configuration.web_lc.name
  min_size             = var.web_instances_min
  max_size             = var.web_instances_max
  desired_capacity     = var.web_instances_desired
  health_check_type    = "EC2"
  vpc_zone_identifier  = var.web_asg_subnets
  target_group_arns    = var.alb_tgs

  tag {
    key = "Name"
    value = var.web_instance_name_tag
    propagate_at_launch = true
  }
}

