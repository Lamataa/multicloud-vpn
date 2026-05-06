variable "zona" {
  type        = string
  description = "Zona GCP"
}

variable "subnet_id" {
  type        = string
  description = "Self-link da subnet GCP"
}

variable "tipo_maquina" {
  type        = string
  description = "Tipo da máquina GCP"
}

variable "ssh_public_key" {
  type        = string
  sensitive   = true
  description = "Chave SSH pública"
}

variable "usuario_ssh" {
  type        = string
  description = "Usuário SSH da VM"
}
