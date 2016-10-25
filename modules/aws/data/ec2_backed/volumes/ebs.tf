resource "aws_ebs_volume" "primary" {
  availability_zone = "${var.availability_zone}"
  size              = "${var.primary_volume_size}"
  type              = "${var.primary_volume_type}"

  tags {
    Name = "${var.name}-primary-volume"
  }
}

resource "aws_ebs_volume" "backup" {
  availability_zone = "${var.availability_zone}"
  size              = "${var.backup_volume_size}"
  type              = "${var.backup_volume_type}"

  tags {
    Name = "${var.name}-backup-volume"
  }
}

output "primary_id" {
  value = "${aws_ebs_volume.primary.id}"
}

output "backup_id" {
  value = "${aws_ebs_volume.backup.id}"
}
