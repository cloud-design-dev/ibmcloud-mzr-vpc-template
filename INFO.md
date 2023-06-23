<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | 1.54.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cos"></a> [cos](#module\_cos) | git::https://github.com/terraform-ibm-modules/terraform-ibm-cos | v6.7.0 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | git::https://github.com/terraform-ibm-modules/terraform-ibm-resource-group.git | v1.0.5 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-ibm-modules/vpc/ibm//modules/security-group | 1.1.1 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-ibm-modules/vpc/ibm//modules/vpc | 1.1.1 |

## Resources

| Name | Type |
|------|------|
| [ibm_iam_authorization_policy.cos_flowlogs](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/resources/iam_authorization_policy) | resource |
| [ibm_is_floating_ip.example](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/resources/is_floating_ip) | resource |
| [ibm_is_flow_log.frontend_collector](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/resources/is_flow_log) | resource |
| [ibm_is_ssh_key.generated_key](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/resources/is_ssh_key) | resource |
| [null_resource.create_private_key](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_string.prefix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [tls_private_key.ssh](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [ibm_is_ssh_key.sshkey](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/data-sources/is_ssh_key) | data source |
| [ibm_is_zones.regional](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/data-sources/is_zones) | data source |
| [ibm_resource_instance.cos](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/data-sources/resource_instance) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_classic_access"></a> [classic\_access](#input\_classic\_access) | Allow classic access to the VPC. | `bool` | `false` | no |
| <a name="input_default_address_prefix"></a> [default\_address\_prefix](#input\_default\_address\_prefix) | The address prefix to use for the VPC. Default is set to auto. | `string` | `"auto"` | no |
| <a name="input_existing_cos_instance"></a> [existing\_cos\_instance](#input\_existing\_cos\_instance) | Name of an existing COS instance to use for resources. If not set, a new COS instance will be created. | `string` | n/a | yes |
| <a name="input_existing_resource_group"></a> [existing\_resource\_group](#input\_existing\_resource\_group) | Name of an existing Resource Group to use for resources. If not set, a new Resource Group will be created. | `string` | n/a | yes |
| <a name="input_existing_ssh_key"></a> [existing\_ssh\_key](#input\_existing\_ssh\_key) | Name of an existing SSH key in the region. If not set, a new SSH key will be created. | `string` | n/a | yes |
| <a name="input_frontend_rules"></a> [frontend\_rules](#input\_frontend\_rules) | A list of security group rules to be added to the Frontend security group | <pre>list(<br>    object({<br>      name      = string<br>      direction = string<br>      remote    = string<br>      tcp = optional(<br>        object({<br>          port_max = optional(number)<br>          port_min = optional(number)<br>        })<br>      )<br>      udp = optional(<br>        object({<br>          port_max = optional(number)<br>          port_min = optional(number)<br>        })<br>      )<br>      icmp = optional(<br>        object({<br>          type = optional(number)<br>          code = optional(number)<br>        })<br>      )<br>    })<br>  )</pre> | <pre>[<br>  {<br>    "direction": "inbound",<br>    "ip_version": "ipv4",<br>    "name": "inbound-http",<br>    "remote": "0.0.0.0/0",<br>    "tcp": {<br>      "port_max": 80,<br>      "port_min": 80<br>    }<br>  },<br>  {<br>    "direction": "inbound",<br>    "ip_version": "ipv4",<br>    "name": "inbound-https",<br>    "remote": "0.0.0.0/0",<br>    "tcp": {<br>      "port_max": 443,<br>      "port_min": 443<br>    }<br>  },<br>  {<br>    "direction": "inbound",<br>    "ip_version": "ipv4",<br>    "name": "inbound-ssh",<br>    "remote": "0.0.0.0/0",<br>    "tcp": {<br>      "port_max": 22,<br>      "port_min": 22<br>    }<br>  },<br>  {<br>    "direction": "inbound",<br>    "icmp": {<br>      "code": 0,<br>      "type": 8<br>    },<br>    "ip_version": "ipv4",<br>    "name": "inbound-icmp",<br>    "remote": "0.0.0.0/0"<br>  },<br>  {<br>    "direction": "outbound",<br>    "ip_version": "ipv4",<br>    "name": "dns-outbound",<br>    "remote": "0.0.0.0/0",<br>    "udp": {<br>      "port_max": 53,<br>      "port_min": 53<br>    }<br>  }<br>]</pre> | no |
| <a name="input_project_prefix"></a> [project\_prefix](#input\_project\_prefix) | Prefix to use for resource names | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | IBM Cloud region where resources will be deployed | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS --><!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_ibm"></a> [ibm](#provider\_ibm) | 1.54.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cos"></a> [cos](#module\_cos) | git::https://github.com/terraform-ibm-modules/terraform-ibm-cos | v6.7.0 |
| <a name="module_mgmt_vpc"></a> [mgmt\_vpc](#module\_mgmt\_vpc) | ./modules/vpc | n/a |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | git::https://github.com/terraform-ibm-modules/terraform-ibm-resource-group.git | v1.0.5 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-ibm-modules/vpc/ibm//modules/security-group | 1.1.1 |
| <a name="module_workload_cos_bucket"></a> [workload\_cos\_bucket](#module\_workload\_cos\_bucket) | git::https://github.com/terraform-ibm-modules/terraform-ibm-cos | v6.7.0 |
| <a name="module_workload_vpc"></a> [workload\_vpc](#module\_workload\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [ibm_iam_authorization_policy.cos_flowlogs](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/resources/iam_authorization_policy) | resource |
| [ibm_is_floating_ip.frontend](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/resources/is_floating_ip) | resource |
| [ibm_is_flow_log.mgmt_frontend_collector](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/resources/is_flow_log) | resource |
| [ibm_is_flow_log.workload_frontend_collector](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/resources/is_flow_log) | resource |
| [ibm_is_instance.bastion](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/resources/is_instance) | resource |
| [ibm_is_instance.worker](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/resources/is_instance) | resource |
| [ibm_is_network_acl.workload](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/resources/is_network_acl) | resource |
| [ibm_is_ssh_key.generated_key](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/resources/is_ssh_key) | resource |
| [ibm_tg_connection.management](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/resources/tg_connection) | resource |
| [ibm_tg_connection.workload](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/resources/tg_connection) | resource |
| [ibm_tg_gateway.management](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/resources/tg_gateway) | resource |
| [null_resource.create_private_key](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_string.prefix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [tls_private_key.ssh](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [ibm_is_image.base](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/data-sources/is_image) | data source |
| [ibm_is_ssh_key.sshkey](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/data-sources/is_ssh_key) | data source |
| [ibm_is_zones.regional](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/data-sources/is_zones) | data source |
| [ibm_resource_instance.cos](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.54.0/docs/data-sources/resource_instance) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_ip_spoofing"></a> [allow\_ip\_spoofing](#input\_allow\_ip\_spoofing) | Allow IP spoofing for the bastion host. | `bool` | `false` | no |
| <a name="input_classic_access"></a> [classic\_access](#input\_classic\_access) | Allow classic access to the VPC. | `bool` | `false` | no |
| <a name="input_default_address_prefix"></a> [default\_address\_prefix](#input\_default\_address\_prefix) | The address prefix to use for the VPC. Default is set to auto. | `string` | `"manual"` | no |
| <a name="input_existing_cos_instance"></a> [existing\_cos\_instance](#input\_existing\_cos\_instance) | Name of an existing COS instance to use for resources. If not set, a new COS instance will be created. | `string` | n/a | yes |
| <a name="input_existing_resource_group"></a> [existing\_resource\_group](#input\_existing\_resource\_group) | Name of an existing Resource Group to use for resources. If not set, a new Resource Group will be created. | `string` | n/a | yes |
| <a name="input_existing_ssh_key"></a> [existing\_ssh\_key](#input\_existing\_ssh\_key) | Name of an existing SSH key in the region. If not set, a new SSH key will be created. | `string` | n/a | yes |
| <a name="input_frontend_rules"></a> [frontend\_rules](#input\_frontend\_rules) | A list of security group rules to be added to the Frontend security group | <pre>list(<br>    object({<br>      name      = string<br>      direction = string<br>      remote    = string<br>      tcp = optional(<br>        object({<br>          port_max = optional(number)<br>          port_min = optional(number)<br>        })<br>      )<br>      udp = optional(<br>        object({<br>          port_max = optional(number)<br>          port_min = optional(number)<br>        })<br>      )<br>      icmp = optional(<br>        object({<br>          type = optional(number)<br>          code = optional(number)<br>        })<br>      )<br>    })<br>  )</pre> | <pre>[<br>  {<br>    "direction": "inbound",<br>    "ip_version": "ipv4",<br>    "name": "inbound-http",<br>    "remote": "0.0.0.0/0",<br>    "tcp": {<br>      "port_max": 80,<br>      "port_min": 80<br>    }<br>  },<br>  {<br>    "direction": "inbound",<br>    "ip_version": "ipv4",<br>    "name": "inbound-https",<br>    "remote": "0.0.0.0/0",<br>    "tcp": {<br>      "port_max": 443,<br>      "port_min": 443<br>    }<br>  },<br>  {<br>    "direction": "inbound",<br>    "ip_version": "ipv4",<br>    "name": "inbound-ssh",<br>    "remote": "0.0.0.0/0",<br>    "tcp": {<br>      "port_max": 22,<br>      "port_min": 22<br>    }<br>  },<br>  {<br>    "direction": "inbound",<br>    "icmp": {<br>      "code": 0,<br>      "type": 8<br>    },<br>    "ip_version": "ipv4",<br>    "name": "inbound-icmp",<br>    "remote": "0.0.0.0/0"<br>  },<br>  {<br>    "direction": "outbound",<br>    "ip_version": "ipv4",<br>    "name": "dns-outbound",<br>    "remote": "0.0.0.0/0",<br>    "udp": {<br>      "port_max": 53,<br>      "port_min": 53<br>    }<br>  }<br>]</pre> | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | The name of the image to use for the bastion host. | `string` | `"ibm-ubuntu-22-04-2-minimal-amd64-1"` | no |
| <a name="input_instance_profile"></a> [instance\_profile](#input\_instance\_profile) | The profile to use for the bastion host. | `string` | `"cx2-2x4"` | no |
| <a name="input_management_address_prefix"></a> [management\_address\_prefix](#input\_management\_address\_prefix) | The address prefix to use for the management subnet. Default is set to 172.16.0.0/18 | `string` | `"172.16.0.0/18"` | no |
| <a name="input_metadata_service_enabled"></a> [metadata\_service\_enabled](#input\_metadata\_service\_enabled) | Enable metadata service for the bastion host. | `bool` | `true` | no |
| <a name="input_project_prefix"></a> [project\_prefix](#input\_project\_prefix) | Prefix to use for resource names | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | IBM Cloud region where resources will be deployed | `string` | n/a | yes |
| <a name="input_workload_address_prefix"></a> [workload\_address\_prefix](#input\_workload\_address\_prefix) | The address prefix to use for the workload subnet. Default is set to 192.168.0.0/18 | `string` | `"192.168.0.0/18"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_ip"></a> [bastion\_ip](#output\_bastion\_ip) | n/a |
| <a name="output_worker_ip"></a> [worker\_ip](#output\_worker\_ip) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
