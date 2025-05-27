locals {
  prefix                           = "cmtr-f5n7jzgb-mod9"
  resource_group_name              = format("%s-rg", local.prefix)
  vnet_name                        = format("%s-vnet", local.prefix)
  aks_subnet_name                  = "aks-snet"
  aks_subnet_id                    = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworks/%s/subnets/%s", var.subscription_id, local.resource_group_name, local.vnet_name, local.aks_subnet_name)
  network_rule_collection_name     = format("%s-net-rules", local.prefix)
  application_rule_collection_name = format("%s-app-rules", local.prefix)
  nat_rule_collection_name         = format("%s-nat-rules", local.prefix)
  default_route_name               = format("%s-default-route", local.prefix)
}