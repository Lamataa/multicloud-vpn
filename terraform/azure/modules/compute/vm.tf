resource "azurerm_public_ip" "main" {
  name                = "fiap-pip-rm562093"
  location            = var.localizacao
  resource_group_name = var.nome_rg
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "main" {
  name                = "fiap-nic-rm562093"
  location            = var.localizacao
  resource_group_name = var.nome_rg

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                  = "fiap-vm-rm562093"
  location              = var.localizacao
  resource_group_name   = var.nome_rg
  size                  = var.tamanho_vm
  admin_username        = var.usuario_admin
  network_interface_ids = [azurerm_network_interface.main.id]

  admin_ssh_key {
    username   = var.usuario_admin
    public_key = var.ssh_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  custom_data = filebase64("${path.module}/cloud_init.sh")
}
