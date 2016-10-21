variable "name" {}

variable "security_groups" {}

variable "public_subnets" {}

resource "aws_elb" "management_elb" {
  name = "${var.name}-elb"

  #availability_zones        = "${split(",", var.azs)}"
  subnets                   = ["${split(",", var.public_subnets)}"]
  cross_zone_load_balancing = true
  internal                  = false
  security_groups           = ["${var.security_groups}"]

  listener {
    instance_port     = 444
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 81
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 4
    timeout             = 5

    target   = "HTTP:80/ping"
    interval = 7
  }

  cross_zone_load_balancing = true
}

resource "aws_proxy_protocol_policy" "management_elb_policy" {
  load_balancer  = "${aws_elb.management_elb.name}"
  instance_ports = ["81", "444"]
}

output "management_elb_id" {
  value = "${aws_elb.management_elb.id}"
}
