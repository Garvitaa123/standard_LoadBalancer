resource "azurerm_network_interface" "web_vm1" {
  name                = "${var.prefix}-web-vm1-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_lb_nat_rule" "web_vm1" {
  name                           = "${var.prefix}-web-vm1-nat"
  resource_group_name            = azurerm_resource_group.main.name
  loadbalancer_id                = azurerm_lb.main.id
  frontend_ip_configuration_name = azurerm_lb.main.frontend_ip_configuration[0].name
  protocol                       = "Tcp"
  frontend_port                  = 8001
  backend_port                   = 80
}

resource "azurerm_network_interface_nat_rule_association" "web_vm1" {
  network_interface_id  = azurerm_network_interface.web_vm1.id
  ip_configuration_name = "internal"
  nat_rule_id           = azurerm_lb_nat_rule.web_vm1.id
}

resource "azurerm_linux_virtual_machine" "web_vm1" {
  name                            = "${var.prefix}-web-vm1"
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  size                            = var.vm_size
  zone                            = var.availability_zone
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.web_vm1.id]

  os_disk {
    name                 = "${var.prefix}-web-vm1-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
