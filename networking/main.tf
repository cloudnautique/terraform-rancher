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
