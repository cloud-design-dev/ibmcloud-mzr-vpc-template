output "connection_info" {
  depends_on  = [ibm_is_instance.bastion]
  description = "Connection info for the IBM Cloud Bastion Instance"
  value       = "ssh root@${ibm_is_floating_ip.frontend.address}"
}