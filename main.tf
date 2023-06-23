locals {
  prefix      = var.project_prefix != "" ? var.project_prefix : "${random_string.prefix.0.result}"
  ssh_key_ids = var.existing_ssh_key != "" ? [data.ibm_is_ssh_key.sshkey[0].id] : [ibm_is_ssh_key.generated_key[0].id]

  cos_instance = var.existing_cos_instance != "" ? data.ibm_resource_instance.cos.0.id : null
  cos_guid     = var.existing_cos_instance != "" ? data.ibm_resource_instance.cos.0.guid : substr(trim(trimprefix(module.cos.cos_instance_id, "crn:v1:bluemix:public:cloud-object-storage:global:a/"), "::"), 33, -1)


  deploy_date = formatdate("YYYYMMDD", timestamp())

  zones = length(data.ibm_is_zones.regional.zones)

  vpc_zones = {
    for zone in range(local.zones) : zone => {
      zone = "${var.region}-${zone + 1}"
    }
  }

  frontend_rules = [
    for r in var.frontend_rules : {
      name       = r.name
      direction  = r.direction
      remote     = lookup(r, "remote", null)
      ip_version = lookup(r, "ip_version", null)
      icmp       = lookup(r, "icmp", null)
      tcp        = lookup(r, "tcp", null)
      udp        = lookup(r, "udp", null)
    }
  ]

  tags = [
    "provider:ibm",
    "workspace:${terraform.workspace}",
  ]
}

# IF a resource group was not provided, create a new one
module "resource_group" {
  source                       = "git::https://github.com/terraform-ibm-modules/terraform-ibm-resource-group.git?ref=v1.0.5"
  resource_group_name          = var.existing_resource_group == null ? "${local.prefix}-resource-group" : null
  existing_resource_group_name = var.existing_resource_group
}

# Generate a random string if a project prefix was not provided
resource "random_string" "prefix" {
  count   = var.project_prefix != "" ? 0 : 1
  length  = 4
  special = false
  upper   = false
  numeric = false
}

# Generate a new SSH key if one was not provided
resource "tls_private_key" "ssh" {
  count     = var.existing_ssh_key != "" ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Add a new SSH key to the region if one was created
resource "ibm_is_ssh_key" "generated_key" {
  count          = var.existing_ssh_key != "" ? 0 : 1
  name           = "${local.prefix}-${var.region}-key"
  public_key     = tls_private_key.ssh.0.public_key_openssh
  resource_group = module.resource_group.resource_group_id
  tags           = local.tags
}

# Write private key to file if it was generated
resource "null_resource" "create_private_key" {
  count = var.existing_ssh_key != "" ? 0 : 1
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.ssh.0.private_key_pem}' > ./'${local.prefix}'.pem
      chmod 400 ./'${local.prefix}'.pem
    EOT
  }
}

module "workload_vpc" {
  source                 = "./modules/vpc"
  vpc_name               = "${local.prefix}-wrk-vpc"
  default_address_prefix = "manual"
  resource_group_id      = module.resource_group.resource_group_id
  default_cidr           = var.workload_address_prefix
  tags                   = concat(local.tags, ["environment:workload"])
  zones                  = [local.vpc_zones[0].zone, local.vpc_zones[1].zone, local.vpc_zones[2].zone]
}

module "mgmt_vpc" {
  source                 = "./modules/vpc"
  vpc_name               = "${local.prefix}-mgmt-vpc"
  default_address_prefix = "manual"
  resource_group_id      = module.resource_group.resource_group_id
  default_cidr           = var.management_address_prefix
  tags                   = concat(local.tags, ["environment:management"])
  network_acl            = ibm_is_network_acl.workload.id
  zones                  = [local.vpc_zones[0].zone, local.vpc_zones[1].zone, local.vpc_zones[2].zone]
}

module "security_group" {
  source                = "terraform-ibm-modules/vpc/ibm//modules/security-group"
  version               = "1.1.1"
  create_security_group = true
  name                  = "${local.prefix}-mgmt-frontend-sg"
  vpc_id                = module.mgmt_vpc.vpc_id
  resource_group_id     = module.resource_group.resource_group_id
  security_group_rules  = local.frontend_rules
}

resource "ibm_is_instance" "bastion" {
  name           = "${local.prefix}-bastion"
  vpc            = module.mgmt_vpc.vpc_id
  image          = data.ibm_is_image.base.id
  profile        = var.instance_profile
  resource_group = module.resource_group.resource_group_id

  metadata_service {
    enabled            = var.metadata_service_enabled
    protocol           = "https"
    response_hop_limit = 5
  }

  boot_volume {
    name = "${local.prefix}-bastion-volume"
  }

  primary_network_interface {
    subnet            = module.mgmt_vpc.subnet_ids[0]
    allow_ip_spoofing = var.allow_ip_spoofing
    security_groups   = [module.security_group.security_group_id[0]]
  }

  user_data = file("${path.module}/init.yaml")
  zone      = local.vpc_zones[0].zone
  keys      = local.ssh_key_ids
  tags      = concat(local.tags, ["zone:${local.vpc_zones[0].zone}"])
}

resource "ibm_is_floating_ip" "frontend" {
  name = "${local.prefix}-${local.vpc_zones[0].zone}-fip"
  # zone           = var.enable_bastion ? null : local.vpc_zones[0].zone
  target = ibm_is_instance.bastion.primary_network_interface[0].id
  # target         = var.enable_bastion ? ibm_is_instance.bastion.primary_network_interface[0].id : null
  resource_group = module.resource_group.resource_group_id
  tags           = local.tags
}

resource "ibm_is_instance" "worker" {
  name           = "${local.prefix}-worker"
  vpc            = module.workload_vpc.vpc_id
  image          = data.ibm_is_image.base.id
  profile        = var.instance_profile
  resource_group = module.resource_group.resource_group_id

  metadata_service {
    enabled            = var.metadata_service_enabled
    protocol           = "https"
    response_hop_limit = 5
  }

  boot_volume {
    name = "${local.prefix}-worker-volume"
  }

  primary_network_interface {
    subnet            = module.workload_vpc.subnet_ids[0]
    allow_ip_spoofing = var.allow_ip_spoofing
    security_groups   = [module.workload_vpc.default_security_group]
  }

  user_data = file("${path.module}/init.yaml")
  zone      = local.vpc_zones[0].zone
  keys      = local.ssh_key_ids
  tags      = concat(local.tags, ["zone:${local.vpc_zones[0].zone}"])
}

module "cos" {
  create_cos_instance      = var.existing_cos_instance != "" ? false : true
  source                   = "git::https://github.com/terraform-ibm-modules/terraform-ibm-cos?ref=v6.7.0"
  resource_group_id        = module.resource_group.resource_group_id
  region                   = var.region
  bucket_name              = "${local.prefix}-mgmt-collector-bucket"
  create_hmac_key          = (var.existing_cos_instance != "" ? false : true)
  create_cos_bucket        = true
  kms_encryption_enabled   = false
  hmac_key_name            = (var.existing_cos_instance != "" ? null : "${local.prefix}-hmac-key")
  cos_instance_name        = (var.existing_cos_instance != "" ? null : "${local.prefix}-cos-instance")
  cos_tags                 = local.tags
  existing_cos_instance_id = (var.existing_cos_instance != "" ? local.cos_instance : null)
}

module "workload_cos_bucket" {
  source                   = "git::https://github.com/terraform-ibm-modules/terraform-ibm-cos?ref=v6.7.0"
  bucket_name              = "${local.prefix}-workload-collector-bucket"
  create_cos_instance      = false
  resource_group_id        = module.resource_group.resource_group_id
  region                   = var.region
  create_hmac_key          = false
  create_cos_bucket        = true
  kms_encryption_enabled   = false
  hmac_key_name            = null
  cos_instance_name        = null
  cos_tags                 = local.tags
  existing_cos_instance_id = local.cos_instance
}

resource "ibm_iam_authorization_policy" "cos_flowlogs" {
  count                       = var.existing_cos_instance != "" ? 0 : 1
  depends_on                  = [module.cos]
  source_service_name         = "is"
  source_resource_type        = "flow-log-collector"
  target_service_name         = "cloud-object-storage"
  target_resource_instance_id = local.cos_guid
  roles                       = ["Writer", "Reader"]
}

resource "ibm_is_flow_log" "mgmt_frontend_collector" {
  depends_on     = [ibm_iam_authorization_policy.cos_flowlogs]
  name           = "${local.prefix}-mgmt-frontend-subnet-collector"
  target         = module.mgmt_vpc.vpc_id
  active         = true
  storage_bucket = module.cos.bucket_name
}

resource "ibm_is_flow_log" "workload_frontend_collector" {
  depends_on     = [ibm_iam_authorization_policy.cos_flowlogs]
  name           = "${local.prefix}-mgmt-frontend-subnet-collector"
  target         = module.workload_vpc.vpc_id
  active         = true
  storage_bucket = module.workload_cos_bucket.bucket_name
}

resource "ibm_tg_gateway" "management" {
  name           = "${local.prefix}-mgmt-tgw"
  location       = var.region
  global         = true
  resource_group = module.resource_group.resource_group_id
}

resource "ibm_tg_connection" "management" {
  gateway      = ibm_tg_gateway.management.id
  network_type = "vpc"
  name         = "${local.prefix}-mgmt-connection"
  network_id   = module.mgmt_vpc.vpc_crn
}

resource "ibm_tg_connection" "workload" {
  gateway      = ibm_tg_gateway.management.id
  network_type = "vpc"
  name         = "${local.prefix}-wrkld-connection"
  network_id   = module.workload_vpc.vpc_crn
}