output "azure_firewall_public_ip" {
  description = "The public IP address assigned to the Azure Firewall."
  value       = azurerm_public_ip.firewall_pip.ip_address
}

output "azure_firewall_private_ip" {
  description = "The private IP address of the Azure Firewall inside the VNet."
  value       = azurerm_firewall.afw.ip_configuration[0].private_ip_address
}