module "rede" {
  source      = "./modules/rede"
  rede_cidr   = var.rede_cidr
  subnet_cidr = var.subnet_cidr
}

module "compute" {
  source         = "./modules/compute"
  vpc_id         = module.rede.vpc_id
  subnet_id      = module.rede.subnet_id
  rede_cidr      = var.rede_cidr
  gcp_rede_cidr  = var.gcp_rede_cidr
  ami            = var.ami
  tipo_instancia = var.tipo_instancia
  ssh_public_key = var.ssh_public_key
  depends_on     = [module.rede]
}
