output "public_ip" {
  description = "IP público da VM Azure"
  value       = azurerm_public_ip.main.ip_address
}

output "private_ip" {
  description = "IP privado da VM Azure"
  value       = azurerm_network_interface.main.private_ip_address
}
