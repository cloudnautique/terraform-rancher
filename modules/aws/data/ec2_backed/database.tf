# EC2 Database server

module "volumes" {
  source = "./volumes"

  name              = "${var.name}-mysql"
  availability_zone = "${var.availability_zone}"
}

module "compute" {
  source = "./compute"

  name          = "${var.name}"
  ami_id        = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.subnet_id}"

  primary_volume_id  = "${module.volumes.primary_id}"
  backup_volume_id   = "${module.volumes.backup_id}"
  user_data          = "${data.template_file.user_data.rendered}"
  security_group_ids = "${module.security_group.security_group_id}"
}

module "security_group" {
  source = "./sg_db"

  vpc_id              = "${var.vpc_id}"
  source_cidr_blocks  = "${var.source_cidr_blocks}"
  security_group_name = "${var.name}-database-security-group"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/files/userdata.template")}"

  vars {
    mysql_root_password = "${var.mysql_root_password}"
    mysql_user          = "${var.database_username}"
    mysql_password      = "${var.database_password}"
    mysql_database_name = "${var.database_name}"
  }
}

output "name" {
  value = "${var.database_name}"
}

output "username" {
  value = "${var.database_username}"
}

output "endpoint" {
  value = "${module.compute.private_ip}:3306"
}
