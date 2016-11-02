module "iam_instance_profile" {
  source = "./iam"

  name = "${var.name}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/files/userdata.template")}"

  vars {
    eip = "${aws_eip.bastion.public_ip}"
  }
}

module "security_group" {
  source = "./security_group"

  name   = "${var.name}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_eip" "bastion" {
  vpc = true
}

module "asg" {
  source = "./asg"
  name   = "${var.name}"

  bastion_instance_type = "${var.bastion_instance_type}"
  image_id              = "${var.image_id}"
  ssh_key_name          = "${var.ssh_key_name}"
  security_groups       = "${module.security_group.bastion_id}"
  userdata              = "${data.template_file.user_data.rendered}"
  eip                   = "${aws_eip.bastion.public_ip}"
  instance_profile_name = "${module.iam_instance_profile.profile_name}"
  subnet_ids            = "${var.subnet_ids}"
}

output "bastion_ip" {
  value = "${aws_eip.bastion.public_ip}"
}
