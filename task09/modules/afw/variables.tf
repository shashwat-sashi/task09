variable "location" {
  description = "Azure region to deploy resources in"
  type        = string
}

variable "resource_group" {
  description = "Name of the existing resource group"
  type        = string
}

variable "vnet_name" {
  description = "Name of the existing virtual network"
  type        = string
}

variable "aks_subnet_name" {
  description = "Name of the subnet for AKS cluster"
  type        = string
}

variable "resource_prefix" {
  description = "Prefix for all resource names"
  type        = string
}

variable "aks_loadbalancer_ip" {
  description = "Public IP of AKS Load Balancer"
  type        = string
}
