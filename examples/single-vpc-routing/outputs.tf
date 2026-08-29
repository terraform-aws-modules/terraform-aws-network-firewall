output "endpoints" {
  description = "Map of availability zone to the firewall endpoint serving that zone"
  value       = module.network_firewall.endpoints
}

output "routes" {
  description = "Routes the module created to send traffic through the firewall"
  value       = keys(module.network_firewall.routes)
}

output "id" {
  description = "The ID of the firewall"
  value       = module.network_firewall.id
}
