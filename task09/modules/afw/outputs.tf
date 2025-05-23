output "azure_firewall_public_ip" {
  value = azurerm_public_ip.afw.ip_address
}

output "azure_firewall_private_ip" {
  value = azurerm_firewall.afw.ip_configuration[0].private_ip_address
}
