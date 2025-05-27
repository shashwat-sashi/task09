variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space of the existing Virtual Network"
  type        = string
}

variable "aks_loadbalancer_ip" {
  description = "The public IP address of the AKS load balancer"
  type        = string
}

variable "subscription_id" {
  description = "The Azure Subscription ID used to build full resource IDs"
  type        = string
}

variable "firewall_subnet_prefix" {
  description = "Subnet prefix for firewall subnet"
  type        = string
}

variable "default_route_name" {
  description = "Name for the default route"
  type        = string
}