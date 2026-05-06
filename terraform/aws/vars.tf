variable "regiao" {
  type        = string
  default     = "us-east-1"
  description = "Região AWS"
}

variable "rede_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR da VPC"
}

variable "subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "CIDR da subnet pública"
}

variable "ami" {
  type        = string
  default     = "ami-0c02fb55956c7d316"
  description = "AMI Amazon Linux 2023 us-east-1"
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

variable "gcp_rede_cidr" {
  type        = string
  default     = "10.128.0.0/20"
  description = "CIDR da rede GCP para regra ICMP"
}
