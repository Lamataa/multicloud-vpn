resource "azurerm_resource_group" "main" {
  name     = var.nome_rg
  location = var.localizacao
}
