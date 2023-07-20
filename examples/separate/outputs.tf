################################################################################
# Firewall
################################################################################

output "firewall_id" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall"
  value       = module.network_firewall.id
}

output "firewall_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall"
  value       = module.network_firewall.arn
}

output "firewall_status" {
  description = "Nested list of information about the current status of the firewall"
  value       = module.network_firewall.status
}

output "firewall_update_token" {
  description = "A string token used when updating a firewall"
  value       = module.network_firewall.update_token
}

################################################################################
# Firewall Logging Configuration
################################################################################

output "firewall_logging_configuration_id" {
  description = "The Amazon Resource Name (ARN) of the associated firewall"
  value       = module.network_firewall.logging_configuration_id
}

################################################################################
# Firewall Policy
################################################################################

output "firewall_policy_id" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall policy"
  value       = module.network_firewall_policy.id
}

output "firewall_policy_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall policy"
  value       = module.network_firewall_policy.arn
}

output "firewall_policy_update_token" {
  description = "A string token used when updating a firewall policy"
  value       = module.network_firewall_policy.update_token
}

output "firewall_policy_resource_policy_id" {
  description = "The Amazon Resource Name (ARN) of the firewall policy associated with the resource policy"
  value       = module.network_firewall_policy.resource_policy_id
}

################################################################################
# Rule Group - Stateful
################################################################################

output "firewall_rule_group_stateful_id" {
  description = "The Amazon Resource Name (ARN) that identifies the rule group"
  value       = module.network_firewall_rule_group_stateful.id
}

output "firewall_rule_group_stateful_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the rule group"
  value       = module.network_firewall_rule_group_stateful.arn
}

output "firewall_rule_group_stateful_update_token" {
  description = "A string token used when updating the rule group"
  value       = module.network_firewall_rule_group_stateful.update_token
}

output "firewall_rule_group_stateful_resource_policy_id" {
  description = "The Amazon Resource Name (ARN) of the rule group associated with the resource policy"
  value       = module.network_firewall_rule_group_stateful.resource_policy_id
}

################################################################################
# Rule Group - Stateless
################################################################################

output "firewall_rule_group_stateless_id" {
  description = "The Amazon Resource Name (ARN) that identifies the rule group"
  value       = module.network_firewall_rule_group_stateless.id
}

output "firewall_rule_group_stateless_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the rule group"
  value       = module.network_firewall_rule_group_stateless.arn
}

output "firewall_rule_group_stateless_update_token" {
  description = "A string token used when updating the rule group"
  value       = module.network_firewall_rule_group_stateless.update_token
}

output "firewall_rule_group_stateless_resource_policy_id" {
  description = "The Amazon Resource Name (ARN) of the rule group associated with the resource policy"
  value       = module.network_firewall_rule_group_stateless.resource_policy_id
}
