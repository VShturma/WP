#-----modules/compute/main.tf-----

data "aws_ami" "amzn_linux2" {
  owners = ["amazon"]
  most_recent = true
  
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name = "ec2_key_pair"
  public_key = "${file(var.ec2_key_path)}"
}

resource "aws_launch_configuration" "bastion_lc" {
  name = "bastion_lc"
  image_id = "${data.aws_ami.amzn_linux2.id}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.ec2_key_pair.key_name}"
  security_groups = ["${var.bastion_sgs}"]
  associate_public_ip_address = true
  user_data = "${var.bastion_user_data}"
  enable_monitoring = false
  ebs_optimized = false
  

  lifecycle {
    create_before_destroy = true
  }
} 

resource "aws_autoscaling_group" "bastion_asg" {
  name = "bastion_asg"
  launch_configuration = "${aws_launch_configuration.bastion_lc.name}"
  min_size = 0
  max_size = 1
  desired_capacity = 0
  health_check_type = "EC2"
  vpc_zone_identifier = ["${var.bastion_asg_subnets}"]
}
