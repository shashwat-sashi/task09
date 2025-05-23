data "azurerm_virtual_network" "existing" {
  name                = var.vnet_name
  resource_group_name = var.resource_group
}

data "azurerm_subnet" "aks" {
  name                 = var.aks_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group
}

resource "azurerm_subnet" "afw" {
  name                 = local.afw_subnet_name
  resource_group_name  = var.resource_group
  virtual_network_name = var.vnet_name
  address_prefixes     = [local.afw_subnet_cidr]
}

resource "azurerm_public_ip" "afw" {
  name                = "${var.resource_prefix}-pip"
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_firewall" "afw" {
  name                = "${var.resource_prefix}-afw"
  location            = var.location
  resource_group_name = var.resource_group
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.afw.id
    public_ip_address_id = azurerm_public_ip.afw.id
  }
}

resource "azurerm_route_table" "afw" {
  name                = "${var.resource_prefix}-rt"
  location            = var.location
  resource_group_name = var.resource_group
}

resource "azurerm_route" "afw_default" {
  name                   = local.default_route
  resource_group_name    = var.resource_group
  route_table_name       = azurerm_route_table.afw.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.afw.ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "aks" {
  subnet_id      = data.azurerm_subnet.aks.id
  route_table_id = azurerm_route_table.afw.id
}

resource "azurerm_firewall_application_rule_collection" "app_rules" {
  name                = "${var.resource_prefix}-app-rc"
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.resource_group
  priority            = 100
  action              = "Allow"

  dynamic "rule" {
    for_each = local.application_rules
    content {
      name             = rule.value.name
      source_addresses = rule.value.source_addresses
      protocol {
        type = rule.value.protocol.type
        port = rule.value.protocol.port
      }
      target_fqdns = rule.value.target_fqdns
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "net_rules" {
  name                = "${var.resource_prefix}-net-rc"
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.resource_group
  priority            = 200
  action              = "Allow"

  dynamic "rule" {
    for_each = local.network_rules
    content {
      name                  = rule.value.name
      source_addresses      = rule.value.source_addresses
      destination_addresses = rule.value.destination_addresses
      destination_ports     = rule.value.destination_ports
      protocols             = rule.value.protocols
    }
  }
}

resource "azurerm_firewall_nat_rule_collection" "nat_rules" {
  name                = "${var.resource_prefix}-nat-rc"
  azure_firewall_name = azurerm_firewall.afw.name
  resource_group_name = var.resource_group
  priority            = 300
  action              = "Dnat"

  dynamic "rule" {
    for_each = local.nat_rules
    content {
      name                  = rule.value.name
      protocols             = rule.value.protocols
      source_addresses      = rule.value.source_addresses
      destination_addresses = rule.value.destination_addresses
      destination_ports     = rule.value.destination_ports
      translated_address    = rule.value.translated_address
      translated_port       = rule.value.translated_port
    }
  }
}