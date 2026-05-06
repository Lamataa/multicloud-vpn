variable "nome_rg" {
  type        = string
  description = "Nome do Resource Group"
}

variable "localizacao" {
  type        = string
  description = "Região Azure"
}

variable "vnet_cidr" {
  type        = string
  description = "CIDR da VNet"
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR da subnet"
}
