variable "name" {}

variable "ami_id" {}

variable "security_groups" {}

variable "instance_type" {
  default = "t2.mediumm"
}

variable "ssh_key_name" {}

variable "scale_min_size" {
  default = "3"
}

variable "scale_max_size" {
  default = "3"
}

variable "scale_desired_size" {
  default = "3"
}

variable "subnet_ids" {}

variable "database_endpoint" {}

variable "database_name" {}

variable "database_user" {}

variable "database_password" {}

variable "registration_url" {}

variable "rancher_version" {}

variable "target_group_arn" {}
