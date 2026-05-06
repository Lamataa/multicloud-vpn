variable "vpc_id" {
  type        = string
  description = "ID da VPC"
}

variable "subnet_id" {
  type        = string
  description = "ID da subnet"
}

variable "rede_cidr" {
  type        = string
  description = "CIDR da VPC para regra ICMP interna"
}

variable "gcp_rede_cidr" {
  type        = string
  description = "CIDR da rede GCP para regra ICMP"
}

variable "ami" {
  type        = string
  description = "AMI da instância EC2"
}

variable "tipo_instancia" {
  type        = string
  default     = "t3.micro"
  description = "Tipo da instância EC2"
}

variable "ssh_public_key" {
  type        = string
  sensitive   = true
  description = "Chave SSH pública"
}
