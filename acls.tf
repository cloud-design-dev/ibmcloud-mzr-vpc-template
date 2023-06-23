resource "ibm_is_network_acl" "workload" {
  name           = "${local.prefix}-workload-acl"
  vpc            = module.workload_vpc.vpc_id
  resource_group = module.resource_group.resource_group_id

  rules {
    name        = "outbound-to-mgmt"
    action      = "allow"
    source      = var.workload_address_prefix
    destination = var.management_address_prefix
    direction   = "outbound"
  }
  rules {
    name        = "outbound-to-self"
    action      = "allow"
    source      = var.workload_address_prefix
    destination = var.workload_address_prefix
    direction   = "outbound"
  }
  rules {
    name        = "inbound-to-self"
    action      = "allow"
    source      = var.workload_address_prefix
    destination = var.workload_address_prefix
    direction   = "inbound"
  }
  rules {
    name        = "inbound-to-workload"
    action      = "allow"
    source      = var.management_address_prefix
    destination = var.workload_address_prefix
    direction   = "inbound"
  }
  rules {
    name        = "inbound-services-161"
    action      = "allow"
    source      = "161.26.0.0/16"
    destination = var.workload_address_prefix
    direction   = "inbound"
  }
  rules {
    name        = "inbound-services-166"
    action      = "allow"
    source      = "166.8.0.0/14"
    destination = var.workload_address_prefix
    direction   = "inbound"
  }
  rules {
    name        = "outbound-services-161"
    action      = "allow"
    source      = var.workload_address_prefix
    destination = "161.26.0.0/16"
    direction   = "outbound"
  }
  rules {
    name        = "outbound-services-166"
    action      = "allow"
    source      = var.workload_address_prefix
    destination = "166.8.0.0/14"
    direction   = "outbound"
  }
}