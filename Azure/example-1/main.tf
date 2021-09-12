#############################################################################
# TERRAFORM CONFIG
#############################################################################

terraform {
  backend "azurerm" {
        resource_group_name  = "rg-terraform"
        storage_account_name = "xxxxx"
        container_name       = "xxxxx"
        key                  = "adsvc.vnet.terraform.tfstate"
    }
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
#  subscription_id   = "${var.ARM_SUBSCRIPTION_ID}"
#  tenant_id         = "${var.ARM_TENANT_ID}"
#  client_id         = "${var.ARM_CLIENT_ID}"
#  client_secret     = "${var.ARM_CLIENT_SECRET}"
}

#############################################################################
# DATA
#############################################################################

data "azurerm_subscription" "current" {}
#############################################################################
# RESOURCES
#############################################################################

resource "random_password" "rnd_pass" {
  length  = 16
  special = true
}

resource "azuread_application" "ad_app" {
  display_name = "vnet-peer"
}

resource "azuread_service_principal" "ad_app_svc_prn" {
  application_id = azuread_application.ad_app.application_id
}

resource "azuread_service_principal_password" "ad_app_svc_prn" {
  service_principal_id = azuread_service_principal.ad_app_svc_prn.id
  value                = random_password.rnd_pass.result
  end_date_relative    = "17520h"
}

resource "azurerm_role_definition" "vnet-peering" {
  name  = "allow-vnet-peering"
  scope = data.azurerm_subscription.current.id
  description = "This is a custom role created via Terraform for Vnet Peering"

  permissions {
    actions     = ["Microsoft.Network/virtualNetworks/virtualNetworkPeerings/write", "Microsoft.Network/virtualNetworks/peer/action", "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/read", "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/delete"]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id,
  ]
}



#############################################################################
# FILE OUTPUT
#############################################################################

resource "local_file" "linux" {
  filename = "${path.module}/next-step.txt"
  content  = <<EOF

export TF_VAR_sec_sub_id=${data.azurerm_subscription.current.subscription_id}
export TF_VAR_sec_client_id=${azuread_service_principal.ad_app_svc_prn.application_id}
export TF_VAR_sec_principal_id=${azuread_service_principal.ad_app_svc_prn.id}
export TF_VAR_sec_client_secret='${random_password.rnd_pass.result}'
export TF_VAR_sec_tenant_id=${data.azurerm_subscription.current.tenant_id}
  EOF
}

resource "local_file" "windows" {
  filename = "${path.module}/windows-next-step.txt"
  content  = <<EOF

$env:TF_VAR_sec_sub_id="${data.azurerm_subscription.current.subscription_id}"
$env:TF_VAR_sec_client_id="${azuread_service_principal.ad_app_svc_prn.application_id}"
$env:TF_VAR_sec_principal_id="${azuread_service_principal.ad_app_svc_prn.id}"
$env:TF_VAR_sec_client_secret="${random_password.rnd_pass.result}"
$env:TF_VAR_sec_tenant_id="${data.azurerm_subscription.current.tenant_id}"
  EOF
}

output "service_principal_client_id" {
  value = azuread_service_principal.ad_app_svc_prn.id
}

output "service_principal_client_secret" {
  value = nonsensitive(random_password.rnd_pass.result)
}

