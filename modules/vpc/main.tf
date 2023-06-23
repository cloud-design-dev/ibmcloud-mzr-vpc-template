resource "ibm_is_vpc" "vpc" {
  name                        = var.vpc_name
  resource_group              = var.resource_group_id
  classic_access              = (var.classic_access != null ? var.classic_access : false)
  address_prefix_management   = (var.default_address_prefix != null ? var.default_address_prefix : "auto")
  default_network_acl_name    = "${var.vpc_name}-default-network-acl"
  default_security_group_name = "${var.vpc_name}-default-security-group"
  default_routing_table_name  = "${var.vpc_name}-default-routing-table"
  tags                        = var.tags
}

resource "ibm_is_vpc_address_prefix" "prefix" {
  count = length(var.zones)

  name       = "${var.vpc_name}-prefix-${count.index + 1}"
  zone       = var.zones[count.index]
  vpc        = ibm_is_vpc.vpc.id
  cidr       = cidrsubnet(var.default_cidr, 4, count.index)
  is_default = true
}

resource "ibm_is_subnet" "subnet" {
  count           = length(var.zones)
  depends_on      = [ibm_is_vpc_address_prefix.prefix]
  name            = "${var.vpc_name}-${count.index}-subnet"
  vpc             = ibm_is_vpc.vpc.id
  zone            = var.zones[count.index]
  resource_group  = var.resource_group_id
  ipv4_cidr_block = cidrsubnet(ibm_is_vpc_address_prefix.prefix[count.index].cidr, 2, count.index)
  tags            = var.tags
}


resource "ibm_is_public_gateway" "pgws" {
  count          = length(var.zones)
  name           = "${var.vpc_name}-${count.index}"
  resource_group = var.resource_group_id
  vpc            = ibm_is_vpc.vpc.id
  zone           = var.zones[count.index]
  tags           = var.tags
}