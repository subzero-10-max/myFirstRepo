module "Resource_Group" {
  source = "../module/resource_group"

  name     = local.resource_group_name
  location = local.location
}

module "Virtual_Network" {
  source = "../module/virtual_network"

  for_each = { for virtual_network in local.virtual_networks : virtual_network.name => virtual_network }

  resource_group_name = local.resource_group_name
  location            = local.location
  name                = each.value.name
  address_space       = each.value.address_space

  depends_on = [module.Resource_Group]
}

module "Subnet" {
  source = "../module/subnet"

  for_each = { for subnet in local.subnets : subnet.name => subnet }

  resource_group_name  = local.resource_group_name
  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes

  depends_on = [module.Virtual_Network]
}

module "Public_Ip" {
  source = "../module/public_ip"

  for_each            = { for public_ip in local.public_ips : public_ip.name => public_ip }
  resource_group_name = local.resource_group_name
  location            = local.location
  name                = each.value.name
  allocation_method   = each.value.allocation_method
}

module "Network_Interface" {
  source = "../module/network_interface"

  for_each = { for network_interface in local.network_interfaces : network_interface.name => network_interface }

  resource_group_name                            = local.resource_group_name
  location                                       = local.location
  name                                           = each.value.name
  ip_configuration_name                          = each.value.ip_configuration_name
  ip_configuration_subnet_id                     = each.value.ip_configuration_subnet_id
  ip_configuration_private_ip_address_allocation = each.value.ip_configuration_private_ip_address_allocation
  ip_configuration_public_ip_address_id          = each.value.ip_configuration_public_ip_address_id

  depends_on = [module.Subnet, module.Public_Ip]
}
module "Network_Security_Group" {
  source = "../module/network_security_group"

  for_each            = { for network_security_group in local.network_security_groups : network_security_group.name => network_security_group }
  resource_group_name = local.resource_group_name
  location            = local.location
  name                = each.value.name

  depends_on = [module.Resource_Group]
}

module "Security_Rule" {
  source = "../module/security_rule"

  for_each                    = { for security_rule in local.security_rules : security_rule.name => security_rule }
  resource_group_name         = local.resource_group_name
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  network_security_group_name = each.value.network_security_group_name
  depends_on                  = [module.Network_Security_Group]
}
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = module.Network_Interface["vm-nic"].id
  network_security_group_id = module.Network_Security_Group["vm_security_group"].id
}
module "Windows_Virtual_Machine" {
  source = "../module/windows_virtual_machine"

  for_each            = { for windows_virtual_machine in local.windows_virtual_machines : windows_virtual_machine.name => windows_virtual_machine }
  resource_group_name = local.resource_group_name
  location            = local.location

  name                             = each.value.name
  size                             = each.value.size
  admin_username                   = each.value.admin_username
  admin_password                   = each.value.admin_password
  network_interface_ids            = each.value.network_interface_ids
  os_disk_caching                  = each.value.os_disk_caching
  os_disk_storage_account_type     = each.value.os_disk_storage_account_type
  source_image_reference_publisher = each.value.source_image_reference_publisher
  source_image_reference_offer     = each.value.source_image_reference_offer
  source_image_reference_sku       = each.value.source_image_reference_sku
  source_image_reference_version   = each.value.source_image_reference_version

  depends_on = [module.Network_Interface]
}