variable "prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space of the VNet"
  type        = string
}

variable "aks_subnet_name" {
  description = "AKS subnet name"
  type        = string
}

variable "aks_subnet_id" {
  description = "ID of the AKS subnet"
  type        = string
}

variable "firewall_subnet_prefix" {
  description = "Subnet prefix for firewall subnet"
  type        = string
}

variable "aks_loadbalancer_ip" {
  description = "aks lb ip"
  type        = string
}

variable "network_rule_collection_name" {
  description = "Fully dynamic name for network rule collection"
  type        = string
}

variable "application_rule_collection_name" {
  description = "Fully dynamic name for application rule collection"
  type        = string
}

variable "nat_rule_collection_name" {
  description = "Fully dynamic name for NAT rule collection"
  type        = string
}
