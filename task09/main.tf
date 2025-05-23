module "afw" {
  source              = "./modules/afw"
  location            = local.location
  resource_group      = local.resource_group
  vnet_name           = local.vnet_name
  aks_subnet_name     = local.aks_subnet_name
  resource_prefix     = local.resource_prefix
  aks_loadbalancer_ip = var.aks_loadbalancer_ip
}
