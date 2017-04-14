variable "name" {}

variable "vpc_id" {}

variable "subnet_cidrs" {}

variable "subnet_ids" {}

variable "ssh_key_name" {}

variable "ssl_certificate_arn" {}

variable "spot_enabled" {
  default = "false"
}

variable "number_of_instances" {
  default = "1"
}

variable "ami_id" {}

variable "security_groups" {
  default = ""
}

variable "instance_type" {
  default = "t2.micro"
}

variable "root_volume_size" {
  default = "8"
}

variable "root_volume_type" {
  default = "standard"
}

variable "userdata" {}

variable "health_check_target" {}

resource "aws_launch_configuration" "rancher_env" {
  name_prefix = "Launch-Config-${var.name}"
  image_id    = "${var.ami_id}"

  security_groups = ["${split(",", var.security_groups)}"]

  instance_type               = "${var.instance_type}"
  key_name                    = "${var.ssh_key_name}"
  associate_public_ip_address = false
  ebs_optimized               = false
  user_data                   = "${var.userdata}"

  root_block_device {
    volume_type = "${var.root_volume_type}"
    volume_size = "${var.root_volume_size}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "rancher_servers" {
  name = "${var.name}-compute-asg"

  min_size         = "${var.number_of_instances}"
  max_size         = "${var.number_of_instances}"
  desired_capacity = "${var.number_of_instances}"

  vpc_zone_identifier  = ["${split(",", var.subnet_ids)}"]
  launch_configuration = "${aws_launch_configuration.rancher_env.name}"

  health_check_grace_period = 900
  health_check_type         = "ELB"
  force_delete              = false
  load_balancers            = ["${module.webservice_elb.management_elb_id}"]

  tag {
    key                 = "Name"
    value               = "${var.name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "spot-enabled"
    value               = "${var.spot_enabled}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
