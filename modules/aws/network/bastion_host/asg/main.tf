variable "name" {}

variable "bastion_instance_type" {}

variable "ssh_key_name" {}

variable "instance_profile_name" {}

variable "security_groups" {}

variable "image_id" {}

variable "userdata" {
  default = ""
}

variable "subnet_ids" {}

variable "eip" {}

resource "aws_launch_configuration" "bastion" {
  name_prefix          = "Launch-Config-${var.name}"
  instance_type        = "${var.bastion_instance_type}"
  image_id             = "${var.image_id}"
  key_name             = "${var.ssh_key_name}"
  iam_instance_profile = "${var.instance_profile_name}"

  security_groups = ["${var.security_groups}"]

  user_data = "${var.userdata}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  name = "${var.name}-bastion-asg"

  desired_capacity = 1
  min_size         = 1
  max_size         = 1

  launch_configuration = "${aws_launch_configuration.bastion.name}"
  vpc_zone_identifier  = ["${split(",", var.subnet_ids)}"]

  tag {
    key                 = "Name"
    value               = "${var.name}-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "EIP"
    value               = "${var.eip}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
