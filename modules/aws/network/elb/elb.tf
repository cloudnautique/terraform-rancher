variable "name" {}

variable "security_groups" {}

variable "public_subnets" {}

variable "ssl_certificate_arn" {}

variable "instance_http_port" {
  default = "81"
}

variable "access_logs_enabled" {
  default = 0
}

variable "instance_http_port_proto" {
  default = "tcp"
}

variable "instance_ssl_port_proto" {
  default = "tcp"
}

variable "instance_ssl_port" {
  default = "81"
}

variable "health_check_target" {
  default = "HTTP:80/ping"
}

variable "proxy_proto_port_string" {
  default = "81,444"
}

resource "aws_elb" "management_elb" {
  name = "${var.name}-elb"

  #availability_zones        = "${split(",", var.azs)}"
  subnets                   = ["${split(",", var.public_subnets)}"]
  cross_zone_load_balancing = true
  internal                  = false
  security_groups           = ["${split(",", var.security_groups)}"]

  listener {
    instance_port      = "${var.instance_ssl_port}"
    instance_protocol  = "${var.instance_ssl_port_proto}"
    lb_port            = 443
    lb_protocol        = "ssl"
    ssl_certificate_id = "${var.ssl_certificate_arn}"
  }

  listener {
    instance_port     = "${var.instance_http_port}"
    instance_protocol = "${var.instance_http_port_proto}"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 4
    timeout             = 5

    target   = "${var.health_check_target}"
    interval = 7
  }

  access_logs {
   bucket  = "${var.access_logs_enabled == "1" ? aws_s3_bucket.access_logs.id : "placeholder" }"
    //bucket  = "nobucket"
   enabled = "${var.access_logs_enabled}"
  }

  cross_zone_load_balancing = true
}

resource "aws_s3_bucket" "access_logs" {
    count  = "${var.access_logs_enabled}"
    bucket = "${var.name}-elb-access-logs"
    acl    = "private"

    tags {
      Name = "${var.name}-elb-access-logs"
    }
}

resource "aws_proxy_protocol_policy" "management_elb_policy" {
  load_balancer  = "${aws_elb.management_elb.name}"
  instance_ports = ["${split(",", var.proxy_proto_port_string)}"]
}

output "management_elb_id" {
  value = "${aws_elb.management_elb.id}"
}

output "dns_name" {
  value = "${aws_elb.management_elb.dns_name}"
}
