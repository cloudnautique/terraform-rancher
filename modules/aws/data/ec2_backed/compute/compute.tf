resource "aws_instance" "database_primary" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${var.security_group_ids}"]
  key_name               = "saas-bigsky-production"
  private_ip             = "${var.ip_address}"

  user_data = "${var.user_data}"

  tags {
    Name = "${var.name}-primary-database-server"
  }
}

resource "aws_volume_attachment" "primary" {
  device_name  = "/dev/xvdb"
  volume_id    = "${var.primary_volume_id}"
  instance_id  = "${aws_instance.database_primary.id}"
  skip_destroy = true
}

resource "aws_volume_attachment" "backup" {
  device_name  = "/dev/xvdc"
  volume_id    = "${var.backup_volume_id}"
  instance_id  = "${aws_instance.database_primary.id}"
  skip_destroy = true
}

output "private_ip" {
  value = "${aws_instance.database_primary.private_ip}"
}
