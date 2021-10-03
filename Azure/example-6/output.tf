#############################################################################
# OUTPUTS
#############################################################################

output "vnet_name" {
  description = "Main VNet Name"
  value = "${azurerm_virtual_network.test.name}"
}

output "public_ip" {
  description = "Public_IP"
  value = "${azurerm_public_ip.test.name}"
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.test.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.test.kube_config_raw

  sensitive = true
}
