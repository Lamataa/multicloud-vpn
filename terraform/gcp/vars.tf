variable "projeto" {
  type        = string
  description = "ID do projeto GCP"
}

variable "regiao" {
  type        = string
  default     = "us-east1"
  description = "Região GCP"
}

variable "zona" {
  type        = string
  default     = "us-east1-b"
  description = "Zona GCP"
}

variable "rede_cidr" {
  type        = string
  default     = "10.128.0.0/20"
  description = "CIDR da subnet GCP"
}

variable "tipo_maquina" {
  type        = string
  default     = "e2-micro"
  description = "Tipo da máquina GCP"
}

variable "ssh_public_key" {
  type        = string
  sensitive   = true
  description = "Chave SSH pública"
}

variable "usuario_ssh" {
  type        = string
  default     = "ubuntu"
  description = "Usuário SSH da VM"
}
