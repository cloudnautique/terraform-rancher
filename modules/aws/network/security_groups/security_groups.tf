variable "vpc_id" {}

variable "private_subnet_cidrs" {}

resource "aws_security_group" "management_elb" {
  name        = "management_elb_sg"
  description = "Allow ports rancher "
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "management_allow_elb" {
  name        = "rancher_ha_allow_elb"
  description = "Allow Connection from elb"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 81
    to_port         = 81
    protocol        = "tcp"
    security_groups = ["${aws_security_group.management_elb.id}"]
  }

  ingress {
    from_port       = 444
    to_port         = 444
    protocol        = "tcp"
    security_groups = ["${aws_security_group.management_elb.id}"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.management_elb.id}"]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = ["${aws_security_group.management_elb.id}"]
  }
}

resource "aws_security_group" "management_allow_internal" {
  name        = "rancher_ha_allow_internal"
  description = "Allow Connection from internal"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.private_subnet_cidrs)}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.private_subnet_cidrs)}"]
  }

  ingress {
    from_port   = 81
    to_port     = 81
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.private_subnet_cidrs)}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.private_subnet_cidrs)}"]
  }

  ingress {
    from_port   = 444
    to_port     = 444
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.private_subnet_cidrs)}"]
  }

  ingress {
    from_port   = 18080
    to_port     = 18080
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.private_subnet_cidrs)}"]
  }

  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.private_subnet_cidrs)}"]
  }

  ingress {
    from_port   = 2376
    to_port     = 2376
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.private_subnet_cidrs)}"]
  }

  ingress {
    from_port   = 2888
    to_port     = 2888
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.private_subnet_cidrs)}"]
  }

  ingress {
    from_port   = 3888
    to_port     = 3888
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.private_subnet_cidrs)}"]
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.private_subnet_cidrs)}"]
  }

  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["${split(",", var.private_subnet_cidrs)}"]
  }

  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["${split(",", var.private_subnet_cidrs)}"]
  }
}

output "elb_sg_id" {
  value = "${aws_security_group.management_elb.id}"
}

output "management_node_sgs" {
  value = "${join(",", list(aws_security_group.management_allow_elb.id,
            aws_security_group.management_allow_internal.id))}"
}
