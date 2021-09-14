#############################################################################
# TERRAFORM CONFIG
#############################################################################

terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }

}

provider "azurerm" {
  features {}

}

#############################################################################
# DATA
#############################################################################

data "azurerm_subscription" "current" {}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resources
data "azurerm_resources" "fetchAzure" {
  resource_group_name = "rg-terraform"
}

#############################################################################
# output
#############################################################################

output "rg-name" {
  value = data.azurerm_resources.fetchAzure
}
output "sub-name" {
  value = data.azurerm_subscription.current
}
