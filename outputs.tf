# output "mgmt_vpc" {
#   value = module.mgmt_vpc
# }

# output "mgmt_crn" {
#   value = module.mgmt_vpc.vpc_crn
# }

output "bastion_ip" {
  value = ibm_is_floating_ip.frontend.address
}

output "worker_ip" {
  value = ibm_is_instance.worker.primary_network_interface[0].primary_ip[0].address
}