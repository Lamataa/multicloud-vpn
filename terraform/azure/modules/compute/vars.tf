variable "nome_rg" {
  type        = string
  description = "Nome do Resource Group"
}

variable "localizacao" {
  type        = string
  description = "Região Azure"
}

variable "subnet_id" {
  type        = string
  description = "ID da subnet Azure"
}

variable "tamanho_vm" {
  type        = string
  description = "Tamanho da VM Azure"
}

variable "usuario_admin" {
  type        = string
  description = "Usuário administrador da VM"
}

variable "ssh_public_key" {
  type        = string
  sensitive   = true
  description = "Chave SSH pública"
}
