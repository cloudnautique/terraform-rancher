variable "name" {}

variable "availability_zone" {}

variable "vpc_id" {}

variable "source_cidr_blocks" {
  type = "list"
}

variable "ami_id" {}

variable "instance_type" {}

variable "subnet_id" {}

variable "mysql_root_password" {
  default = "password"
}

variable "database_username" {
  default = "cattle"
}

variable "database_password" {
  default = "cattlepass"
}

variable "database_name" {
  default = "cattle"
}

variable "backup_user" {
  default = "bkupuser"
}

variable "backup_user_password" {
  default = "supers3cret"
}

variable "primary_snapshot_id" {
  default = ""
}

variable "backup_snapshot_id" {
  default = ""
}

variable "ip_address" {
  default = ""
}
