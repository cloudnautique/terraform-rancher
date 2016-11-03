variable "name" {}

variable "vpc_id" {}

variable "subnet_cidrs" {}

variable "subnet_ids" {}

variable "number_of_instances" {
  default = "1"
}

variable "rancher_reg_url" {}

variable "ami_id" {}

variable "instance_type" {
  default = "t2.micro"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/files/userdata.template")}"

  vars {
    rancher_reg_url = "${var.rancher_reg_url}"
  }
}

module "ipsec_security_group" {
  source = "../sg"

  name              = "${var.name}-environment"
  vpc_id            = "${var.vpc_id}"
  environment_cidrs = "${var.subnet_cidrs}"
}

resource "aws_instance" "compute-node" {
  ami = "${var.ami_id}"

  count = "${var.number_of_instances}"

  subnet_id              = "${element(sort(split(",", var.subnet_ids)), count.index % length(split(",", var.subnet_ids)))}"
  instance_type          = "${var.instance_type}"
  user_data              = "${data.template_file.user_data.rendered}"
  vpc_security_group_ids = ["${module.ipsec_security_group.ipsec_id}"]

  lifecycle {
    create_before_destroy = "true"
  }

  tags {
    Name = "${var.name}-${count.index}"
  }
}

output "ipsec_id" {
  value = "${module.ipsec_security_group.ipsec_id}"
}
