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
