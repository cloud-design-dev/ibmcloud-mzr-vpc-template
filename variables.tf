variable "existing_resource_group" {
  description = "Name of an existing Resource Group to use for resources. If not set, a new Resource Group will be created."
  type        = string
  default     = null
}

variable "region" {
  description = "IBM Cloud region where resources will be deployed"
  type        = string
  default     = "us-south"
}

variable "project_prefix" {
  description = "Prefix to use for resource names"
  type        = string
  default     = null
}

variable "existing_ssh_key" {
  description = "Name of an existing SSH key in the region. If not set, a new SSH key will be created."
  type        = string
  default     = null
}