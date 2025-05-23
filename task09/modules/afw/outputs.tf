output "azure_firewall_public_ip" {
  description = "Public IP address assigned to the Azure Firewall"
  value       = azurerm_public_ip.afw.ip_address
}

output "azure_firewall_private_ip" {
  description = "Private IP address assigned to the Azure Firewall inside the VNet"
  value       = azurerm_firewall.afw.ip_configuration[0].private_ip_address
}