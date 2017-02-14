variable "name" {}

variable "ami_id" {}

variable "security_groups" {}

variable "instance_type" {}

variable "ssh_key_name" {}

variable "scale_min_size" {}

variable "scale_max_size" {}

variable "scale_desired_size" {}

variable "target_group_arn" {}

#variable "azs" {}

variable "health_check_type" {
  default = "ELB"
}

variable "subnet_ids" {}

variable "userdata" {}

resource "aws_launch_configuration" "rancher_management" {
  name_prefix = "Launch-Config-${var.name}"
  image_id    = "${var.ami_id}"

  security_groups = ["${split(",", var.security_groups)}"]

  instance_type               = "${var.instance_type}"
  key_name                    = "${var.ssh_key_name}"
  associate_public_ip_address = false
  ebs_optimized               = false
  user_data                   = "${var.userdata}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "rancher_management" {
  name                      = "${var.name}-asg"
  min_size                  = "${var.scale_min_size}"
  max_size                  = "${var.scale_max_size}"
  desired_capacity          = "${var.scale_desired_size}"
  health_check_grace_period = 900
  health_check_type         = "${var.health_check_type}"
  force_delete              = false
  target_group_arns         = ["${split(",", var.target_group_arn)}"]

  #availability_zones        = ["${split(",", var.azs)}"]

  vpc_zone_identifier  = ["${split(",", var.subnet_ids)}"]
  launch_configuration = "${aws_launch_configuration.rancher_management.name}"
  tag {
    key                 = "Name"
    value               = "${var.name}"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

output "id" {
  value = "${aws_autoscaling_group.rancher_management.id}"
}

output "name" {
  value = "${aws_autoscaling_group.rancher_management.name}"
}
