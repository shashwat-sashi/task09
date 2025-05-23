locals {
  afw_subnet_name = "AzureFirewallSubnet"
  afw_subnet_cidr = "10.0.1.0/26"
  default_route   = "default-route"

  # Application rules
  application_rules = [
    {
      name             = "allow-http"
      source_addresses = ["*"]
      protocol         = { type = "Http", port = 80 }
      target_fqdns     = ["*"]
    }
  ]

  # Network rules
  network_rules = [
    {
      name                  = "allow-all-outbound"
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
      protocols             = ["TCP", "UDP"]
    }
  ]

  # NAT rules
  nat_rules = [
    {
      name                  = "nginx"
      protocols             = ["TCP"]
      source_addresses      = ["*"]
      destination_addresses = [azurerm_public_ip.afw.ip_address]
      destination_ports     = ["80"]
      translated_address    = var.aks_loadbalancer_ip
      translated_port       = "80"
    }
  ]
}