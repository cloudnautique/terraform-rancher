data "template_file" "user_data" {
  template = "${file("${path.module}/files/userdata.template")}"

  vars {
    cluster_size      = "${var.scale_desired_size}"
    database_endpoint = "${var.database_endpoint}"
    database_user     = "${var.database_user}"
    database_password = "${var.database_password}"
    database_name     = "${var.database_name}"
    registration_url  = "${var.registration_url}"
    rancher_version   = "${var.rancher_version}"
    ip-addr           = "local-ipv4"
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
  userdata           = "${data.template_file.user_data.rendered}"
  target_group_arn   = "${var.target_group_arn}"

  #azs                = "${var.azs}"
  subnet_ids = "${var.subnet_ids}"
}

output "userdata" {
  value = "${data.template_file.user_data.rendered}"
}
