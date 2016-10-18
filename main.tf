provider "aws" {
  region     = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

module "networking" {
  source = "./modules/aws/network"

  vpc_name             = "${var.aws_env_name}"
  vpc_cidr             = "${var.aws_vpc_cidr}"
  region               = "${var.aws_region}"
  public_subnet_cidrs  = "${var.aws_public_subnet_cidrs}"
  private_subnet_cidrs = "${var.aws_private_subnet_cidrs}"
  azs                  = "${var.aws_subnet_azs}"
}

module "database" {
  source             = "./modules/aws/data"
  vpc_id             = "${module.networking.vpc_id}"
  source_cidr_blocks = "${concat(split(",",var.aws_public_subnet_cidrs),split(",", var.aws_private_subnet_cidrs))}"
  rds_instance_class = "${var.aws_rds_instance_class}"
  db_subnet_ids      = "${concat(split(",", module.networking.private_subnet_ids))}"
}

module "compute" {
  source = "./modules/aws/compute"

  name            = "${var.aws_env_name}-compute"
  ami_id          = "${var.aws_ami_id}"
  instance_type   = "${var.aws_instance_type}"
  ssh_key_name    = "${var.aws_ssh_key_name}"
  load_balancers  = "${module.networking.public_elbs}"
  security_groups = "${module.networking.compute_security_groups}"

  database_endpoint = "${element(split(":", module.database.endpoint),0)}"
  database_name     = "${module.database.name}"
  database_user     = "${module.database.username}"
  database_password = "${var.database_encrypted_password}"
  encryption_key    = "${var.encryption_key}"
  rancher_version   = "${var.rancher_version}"

  registration_url   = "${var.registration_url}"
  ca_chain           = "${var.ca_chain}"
  server_cert        = "${var.server_cert}"
  server_private_key = "${var.server_private_key}"

  #azs             = "${var.aws_subnet_azs}"
  subnet_ids = "${module.networking.public_subnet_ids}"
}

output "subnet_ids" {
  value = "${concat(split(",", module.networking.private_subnet_ids),split(",", module.networking.public_subnet_ids))}"
}

output "vpc_id" {
  value = "${module.networking.vpc_id}"
}

output "db_endpoint" {
  value = "${module.database.endpoint}"
}

output "userdata" {
  value = "${module.compute.userdata}"
}
