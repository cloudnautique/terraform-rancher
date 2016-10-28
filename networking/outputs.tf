output "subnet_ids" {
  value = "${concat(split(",", module.networking.private_subnet_ids),split(",", module.networking.public_subnet_ids))}"
}

output "private_subnet_ids" {
  value = "${module.networking.private_subnet_ids}"
}

output "public_subnet_ids" {
  value = "${module.networking.public_subnet_ids}"
}

output "vpc_id" {
  value = "${module.networking.vpc_id}"
}

output "public_elbs" {
  value = "${module.networking.public_elbs}"
}

output "management_security_groups" {
  value = "${module.networking.management_security_groups}"
}
