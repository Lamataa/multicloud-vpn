output "network_name" {
  description = "Self-link da rede GCP"
  value       = module.rede.network_name
}

output "subnet_id" {
  description = "Self-link da subnet GCP"
  value       = module.rede.subnet_id
}

output "public_ip" {
  description = "IP público da VM GCP"
  value       = module.compute.public_ip
}

output "private_ip" {
  description = "IP privado da VM GCP"
  value       = module.compute.private_ip
}

output "instance_name" {
  description = "Nome da instância GCP"
  value       = module.compute.instance_name
}
