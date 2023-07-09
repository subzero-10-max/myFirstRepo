locals {

  resource_group_name = "Talha_RG"
  location            = "East us"


  virtual_networks = [
    {
      name          = "tempvnet"
      address_space = ["10.0.0.0/16"]
    }
  ]
  subnets = [
    {
      name                 = "default"
      virtual_network_name = "tempvnet"
      address_prefixes     = ["10.0.0.0/24"]
    }
  ]

  public_ips = [
    {
      name              = "VM_pip"
      allocation_method = "Dynamic"
    }
  ]

  network_interfaces = [
    {
      name                                           = "vm-nic"
      ip_configuration_name                          = "vm-ipconfig"
      ip_configuration_subnet_id                     = module.Subnet["default"].id
      ip_configuration_private_ip_address_allocation = "Dynamic"
      ip_configuration_public_ip_address_id          = module.Public_Ip["VM_pip"].id
    }
  ]

  network_security_groups = [
    {
      name = "vm_security_group"
    }
  ]

  security_rules = [
    {
      name                        = "RDP"
      priority                    = 1000
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "3389"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
      network_security_group_name = "vm_security_group"
    }
  ]
  windows_virtual_machines = [
    {
      name                             = "MYSQLSERVERVM"
      size                             = "Standard_B4ms"
      admin_username                   = "talharashid"
      admin_password                   = var.password
      network_interface_ids            = [module.Network_Interface["vm-nic"].id]
      os_disk_caching                  = "ReadWrite"
      os_disk_storage_account_type     = "Premium_LRS"
      source_image_reference_publisher = "microsoftsqlserver"
      source_image_reference_offer     = "sql2019-ws2019"
      source_image_reference_sku       = "standard-gen2"
      source_image_reference_version   = "latest"
    }
  ]
}