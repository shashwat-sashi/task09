module "afw" {
  source                           = "./modules/afw"
  prefix                           = local.prefix
  resource_group_name              = local.resource_group_name
  location                         = var.location
  vnet_name                        = local.vnet_name
  vnet_address_space               = var.vnet_address_space
  aks_subnet_name                  = local.aks_subnet_name
  aks_subnet_id                    = local.aks_subnet_id
  aks_loadbalancer_ip              = var.aks_loadbalancer_ip
  firewall_subnet_prefix           = var.firewall_subnet_prefix
  network_rule_collection_name     = local.network_rule_collection_name
  application_rule_collection_name = local.application_rule_collection_name
  nat_rule_collection_name         = local.nat_rule_collection_name
}