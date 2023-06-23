output "vpc_crn" {
  value = ibm_is_vpc.vpc.crn
}

output "vpc_id" {
  value = ibm_is_vpc.vpc.id
}

output "vpc" {
  value = ibm_is_vpc.vpc
}

output "subnet_ids" {
  value = ibm_is_subnet.subnet.*.id
}

output "default_security_group" {
  value = ibm_is_vpc.vpc.default_security_group
}