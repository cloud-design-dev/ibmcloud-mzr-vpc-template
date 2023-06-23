variable "resource_group_id" {}
variable "tags" {}
variable "zones" {}
variable "vpc_name" {}
variable "default_cidr" {}
variable "default_address_prefix" {}
variable "classic_access" {
  default = false
}

variable "network_acl" {
  default = ""
}