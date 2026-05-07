variable "localizacao" {
  type        = string
  default     = "East US"
  description = "Região Azure"
}

variable "nome_rg" {
  type        = string
  default     = "fiap-vpn-rg-rm562093"
  description = "Nome do Resource Group"
}

variable "vnet_cidr" {
  type        = string
  default     = "172.16.0.0/16"
  description = "CIDR da VNet"
}

variable "subnet_cidr" {
  type        = string
  default     = "172.16.1.0/24"
  description = "CIDR da subnet"
}

variable "tamanho_vm" {
  type        = string
  default     = "Standard_D2s_v3"
  description = "Tamanho da VM Azure"
}

variable "usuario_admin" {
  type        = string
  default     = "azureuser"
  description = "Usuário administrador da VM"
}

variable "ssh_public_key" {
  type        = string
  sensitive   = true
  description = "Chave SSH pública"
}


