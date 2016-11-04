data "template_file" "user_data" {
  template = "${file("${path.module}/files/userdata.template")}"

  vars {
    database_endpoint  = "${var.database_endpoint}"
    database_user      = "${var.database_user}"
    database_password  = "${var.database_password}"
    database_name      = "${var.database_name}"
    server_cert        = "${var.server_cert}"
    server_private_key = "${var.server_private_key}"
    server_name        = "${var.server_name}"
    rancher_version    = "${var.rancher_version}"
    subnet_cidr        = "${var.elb_cidr}"
  }
}

module "asg" {
  source = "./asg"

  name               = "${var.name}"
  ami_id             = "${var.ami_id}"
  security_groups    = "${var.security_groups}"
  instance_type      = "${var.instance_type}"
  ssh_key_name       = "${var.ssh_key_name}"
  scale_min_size     = "${var.scale_min_size}"
  scale_max_size     = "${var.scale_max_size}"
  scale_desired_size = "${var.scale_desired_size}"
  load_balancers     = "${var.load_balancers}"
  userdata           = "${data.template_file.user_data.rendered}"

  #azs                = "${var.azs}"
  subnet_ids = "${var.subnet_ids}"
}

output "userdata" {
  value = "${data.template_file.user_data.rendered}"
}
