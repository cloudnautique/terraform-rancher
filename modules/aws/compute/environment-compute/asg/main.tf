variable "name" {}

variable "vpc_id" {}

variable "subnet_cidrs" {}

variable "subnet_ids" {}

variable "ssh_key_name" {}

variable "ssl_certificate_arn" {}

variable "cattle_agent_ip" {
  default = "local-ipv4"
}

variable "number_of_instances" {
  default = "1"
}

variable "rancher_reg_url" {}

variable "ami_id" {}

variable "additional_security_groups" {
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

module "ipsec_security_group" {
  source = "../../../network/env_security_groups/ipsec"

  name              = "${var.name}-environment"
  vpc_id            = "${var.vpc_id}"
  environment_cidrs = "${var.subnet_cidrs}"
}

module "web_elb_sgs" {
  source = "../../../network/env_security_groups/primary_web_elb"

  name   = "${var.name}-environment"
  vpc_id = "${var.vpc_id}"
}

module "webservice_elb" {
  source = "../../../network/elb"

  name                = "${var.name}-main-elb"
  ssl_certificate_arn = "${var.ssl_certificate_arn}"
  instance_http_port  = 80
  instance_ssl_port   = 80

  health_check_target     = "${var.health_check_target}"
  public_subnets          = "${var.subnet_ids}"
  proxy_proto_port_string = "80,443"
  security_groups         = "${module.web_elb_sgs.web_elb_sg_ids}"
}

resource "aws_launch_configuration" "rancher_env" {
  name_prefix = "Launch-Config-${var.name}"
  image_id    = "${var.ami_id}"

  security_groups = [
    "${concat(list(module.ipsec_security_group.ipsec_id),
      split(",", var.additional_security_groups),
      split(",", module.web_elb_sgs.web_elb_backend_sg_id))}",
  ]

  instance_type               = "${var.instance_type}"
  key_name                    = "${var.ssh_key_name}"
  associate_public_ip_address = false
  ebs_optimized               = true
  user_data                   = "${var.userdata}"

  root_block_device {
    volume_type = "${var.root_volume_type}"
    volume_size = "${var.root_volume_size}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "rancher_compute_nodes" {
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

  lifecycle {
    create_before_destroy = true
  }
}

output "ipsec_id" {
  value = "${module.ipsec_security_group.ipsec_id}"
}
