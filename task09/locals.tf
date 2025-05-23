locals {
  resource_prefix          = var.resource_prefix
  location                 = var.location
  vnet_name                = var.vnet_name
  resource_group           = var.resource_group
  aks_subnet_name          = var.aks_subnet_name
  afw_subnet_name          = "AzureFirewallSubnet"
  afw_subnet_cidr          = "10.0.1.0/26"
  vnet_address_space       = var.vnet_address_space
  aks_subnet_address_space = var.aks_subnet_address_space
}