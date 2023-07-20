################################################################################
# Firewall Policy
################################################################################

output "id" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall policy"
  value       = try(aws_networkfirewall_firewall_policy.this[0].id, null)
}

output "arn" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall policy"
  value       = try(aws_networkfirewall_firewall_policy.this[0].arn, null)
}

output "update_token" {
  description = "A string token used when updating a firewall policy"
  value       = try(aws_networkfirewall_firewall_policy.this[0].update_token, null)
}

################################################################################
# Resource Policy
################################################################################

output "resource_policy_id" {
  description = "The Amazon Resource Name (ARN) of the firewall policy associated with the resource policy"
  value       = try(aws_networkfirewall_resource_policy.this[0].id, null)
}
