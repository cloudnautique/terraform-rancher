variable "name" {}

variable "ami_id" {}

variable "instance_type" {}

variable "ip_address" {
  default = ""
}

variable "subnet_id" {}

variable "primary_volume_id" {}

variable "backup_volume_id" {}

variable "user_data" {}

variable "security_group_ids" {}
