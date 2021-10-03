# provider "random" {
#   version = ">=2.2"
# }

# resource "random_id" "main" {
#   byte_length = 4
# }

# resource "random_string" "main" {
#   length  = 32
#   upper   = true
#   special = true
#   lower   = true
#   number  = true
# }
resource "azurerm_resource_group" "rg_main" {
  name     = var.resource_group_name
  location = var.location
}

#Resources
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
  depends_on = [
    azurerm_resource_group.rg_main
    ]
}



#Virtual Networks
resource "azurerm_virtual_network" "test" {
  name                = var.virtual_network_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = [var.virtual_network_address_prefix]

  subnet {
    name           = var.aks_subnet_name
    address_prefix = var.aks_subnet_address_prefix # Kubernetes Subnet Address prefix
  }

  subnet {
    name           = var.app_gateway_subnet_name
    address_prefix = var.app_gateway_subnet_address_prefix
  }

  tags = var.tags
}

data "azurerm_subnet" "kubesubnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = azurerm_virtual_network.test.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "appgwsubnet" {
  name                 = var.app_gateway_subnet_name
  virtual_network_name = azurerm_virtual_network.test.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

# Public Ip
resource "azurerm_public_ip" "test" {
  name                         = "publicIp1"
  location                     = data.azurerm_resource_group.rg.location
  resource_group_name          = data.azurerm_resource_group.rg.name
  allocation_method            = "Static"
  sku                          = "Standard"
  tags = var.tags
}

