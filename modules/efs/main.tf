#-----modules/efs/main.tf-----

resource "aws_efs_file_system" "wp_efs" {
  creation_token = "wp-efs"
  performance_mode = "${var.efs_performance}"
  
  tags = {
    Name = "wp-efs"
  }
}

resource "aws_efs_mount_target" "alpha" {
  file_system_id = "${aws_efs_file_system.wp_efs.id}"
  subnet_id = "${element(var.efs_subnets, 0)}"
  security_groups = ["${var.efs_sgs}"]
}

resource "aws_efs_mount_target" "beta" {
  file_system_id = "${aws_efs_file_system.wp_efs.id}"
  subnet_id = "${element(var.efs_subnets, 1)}"
  security_groups = ["${var.efs_sgs}"]
}
