variable "aws_env_name" {
  description = "Name for all entities in Rancher HA environment"
}

variable "aws_ssh_key_name" {}

variable "aws_region" {}

variable "aws_vpc_cidr" {}

variable "aws_subnet_azs" {}

variable "aws_public_subnet_cidrs" {}

variable "aws_private_subnet_cidrs" {}

variable "aws_rds_instance_class" {}

variable "aws_ami_id" {}

variable "aws_instance_type" {}

variable "ca_chain" {
  description = "base64 encoded string"
}

variable "encryption_key" {}

variable "server_cert" {
  description = "base64 encoded string"
}

variable "server_private_key" {
  description = "base64 encoded string"
}

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "database_encrypted_password" {}

variable "registration_url" {}

variable "rancher_version" {
  default = "rancher/server"
}
