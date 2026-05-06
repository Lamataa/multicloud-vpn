output "resource_group" {
  description = "Nome do Resource Group Azure"
  value       = var.nome_rg
}

output "public_ip" {
  description = "IP público da VM Azure"
  value       = module.compute.public_ip
}

output "private_ip" {
  description = "IP privado da VM Azure"
  value       = module.compute.private_ip
}
