output "id" { value = azurerm_kubernetes_cluster.kubernetes_cluster.id }

output "current_kubernetes_version" { value = try(azurerm_kubernetes_cluster.kubernetes_cluster.current_kubernetes_version, null) }

output "fqdn" { value = try(azurerm_kubernetes_cluster.kubernetes_cluster.fqdn, null) }

output "private_fqdn" { value = try(azurerm_kubernetes_cluster.kubernetes_cluster.private_fqdn, null) }