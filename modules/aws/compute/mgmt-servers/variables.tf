variable "name" {}

variable "ami_id" {}

variable "elb_cidr" {}

variable "security_groups" {}

variable "instance_type" {
  default = "t2.mediumm"
}

variable "ssh_key_name" {}

variable "scale_min_size" {
  default = "1"
}

variable "scale_max_size" {
  default = "1"
}

variable "scale_desired_size" {
  default = "1"
}

variable "load_balancers" {}

variable "subnet_ids" {}

variable "database_endpoint" {}

variable "database_name" {}

variable "database_user" {}

variable "database_password" {}

variable "ca_chain" {}

variable "server_cert" {}

variable "server_private_key" {}

variable "server_name" {}

variable "rancher_version" {}
