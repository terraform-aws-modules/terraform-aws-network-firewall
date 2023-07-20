################################################################################
# Rule Group
################################################################################

output "id" {
  description = "The Amazon Resource Name (ARN) that identifies the rule group"
  value       = try(aws_networkfirewall_rule_group.this[0].id, null)
}

output "arn" {
  description = "The Amazon Resource Name (ARN) that identifies the rule group"
  value       = try(aws_networkfirewall_rule_group.this[0].arn, null)
}

output "update_token" {
  description = "A string token used when updating the rule group"
  value       = try(aws_networkfirewall_rule_group.this[0].update_token, null)
}

################################################################################
# Resource Policy
################################################################################

output "resource_policy_id" {
  description = "The Amazon Resource Name (ARN) of the rule group associated with the resource policy"
  value       = try(aws_networkfirewall_resource_policy.this[0].id, null)
}
