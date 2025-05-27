resource "azurerm_subnet" "firewall_subnet" {
  name                 = local.firewall_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.firewall_subnet_prefix]
}

resource "azurerm_public_ip" "firewall_pip" {
  name                = local.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_firewall" "afw" {
  name                = local.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.firewall_pip.id
  }

  sku_name = "AZFW_VNet"
  sku_tier = "Standard"
}

resource "azurerm_route_table" "rt" {
  name                = local.route_table_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_route" "default" {
  name                   = local.default_route_name
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.rt.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.afw.ip_configuration[0].private_ip_address
}

resource "azurerm_route" "aks_lv" {
  name                = local.firewall_pip_route_name
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.rt.name
  address_prefix      = "${azurerm_public_ip.firewall_pip.ip_address}/32"
  next_hop_type       = "Internet"

}

resource "azurerm_subnet_route_table_association" "aks" {
  subnet_id      = var.aks_subnet_id
  route_table_id = azurerm_route_table.rt.id
}

resource "azurerm_firewall_network_rule_collection" "network" {
  name                = var.network_rule_collection_name
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.resource_group_name
  priority            = 200
  action              = "Allow"

  dynamic "rule" {
    for_each = local.network_rules
    content {
      name                  = rule.value.name
      protocols             = rule.value.protocols
      source_addresses      = rule.value.source_addresses
      destination_ports     = rule.value.destination_ports
      destination_addresses = rule.value.destination_addresses
    }
  }
}

resource "azurerm_firewall_application_rule_collection" "app" {
  name                = var.application_rule_collection_name
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.resource_group_name
  priority            = 300
  action              = "Allow"

  dynamic "rule" {
    for_each = local.application_rules
    content {
      name             = rule.value.name
      source_addresses = rule.value.source_addresses

      dynamic "protocol" {
        for_each = rule.value.protocols
        content {
          port = protocol.value.port
          type = protocol.value.type
        }
      }

      target_fqdns = rule.value.target_fqdns
    }
  }
}

resource "azurerm_firewall_nat_rule_collection" "nat" {
  name                = var.nat_rule_collection_name
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Dnat"

  rule {
    name                  = "nginx-dnat-http"
    source_addresses      = ["*"]
    destination_ports     = ["80"]
    destination_addresses = [azurerm_public_ip.firewall_pip.ip_address]
    translated_address    = var.aks_loadbalancer_ip
    translated_port       = "80"
    protocols             = ["TCP"]
  }


}