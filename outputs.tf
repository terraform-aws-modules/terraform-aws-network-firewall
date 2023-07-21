################################################################################
# Firewall
################################################################################

output "id" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall"
  value       = module.firewall.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall"
  value       = module.firewall.arn
}

output "status" {
  description = "Nested list of information about the current status of the firewall"
  value       = module.firewall.status
}

output "update_token" {
  description = "A string token used when updating a firewall"
  value       = module.firewall.update_token
}

################################################################################
# Firewall Logging Configuration
################################################################################

output "logging_configuration_id" {
  description = "The Amazon Resource Name (ARN) of the associated firewall"
  value       = module.firewall.logging_configuration_id
}

################################################################################
# Firewall Policy
################################################################################

output "policy_id" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall policy"
  value       = module.policy.id
}

output "policy_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall policy"
  value       = module.policy.arn
}

output "policy_update_token" {
  description = "A string token used when updating a firewall policy"
  value       = module.policy.update_token
}

output "policy_resource_policy_id" {
  description = "The Amazon Resource Name (ARN) of the firewall policy associated with the resource policy"
  value       = module.policy.resource_policy_id
}
