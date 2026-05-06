module "rg" {
  source      = "./modules/rg"
  nome_rg     = var.nome_rg
  localizacao = var.localizacao
}

module "rede" {
  source      = "./modules/rede"
  nome_rg     = var.nome_rg
  localizacao = var.localizacao
  vnet_cidr   = var.vnet_cidr
  subnet_cidr = var.subnet_cidr
  depends_on  = [module.rg]
}

module "compute" {
  source         = "./modules/compute"
  nome_rg        = var.nome_rg
  localizacao    = var.localizacao
  subnet_id      = module.rede.subnet_id
  tamanho_vm     = var.tamanho_vm
  usuario_admin  = var.usuario_admin
  ssh_public_key = var.ssh_public_key
  depends_on     = [module.rede]
}
