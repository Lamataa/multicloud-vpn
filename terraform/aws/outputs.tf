output "vpc_id" {
  description = "ID da VPC AWS"
  value       = module.rede.vpc_id
}

output "public_ip" {
  description = "IP público da instância EC2"
  value       = module.compute.public_ip
}

output "private_ip" {
  description = "IP privado da instância EC2"
  value       = module.compute.private_ip
}

output "instance_id" {
  description = "ID da instância EC2"
  value       = module.compute.instance_id
}
