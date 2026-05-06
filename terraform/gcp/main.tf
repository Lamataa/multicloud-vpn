module "rede" {
  source    = "./modules/rede"
  regiao    = var.regiao
  rede_cidr = var.rede_cidr
}

module "compute" {
  source         = "./modules/compute"
  zona           = var.zona
  subnet_id      = module.rede.subnet_id
  tipo_maquina   = var.tipo_maquina
  ssh_public_key = var.ssh_public_key
  usuario_ssh    = var.usuario_ssh
  depends_on     = [module.rede]
}
