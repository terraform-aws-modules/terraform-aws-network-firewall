################################################################################
# Firewall
################################################################################

output "id" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall"
  value       = try(aws_networkfirewall_firewall.this[0].id, null)
}

output "arn" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall"
  value       = try(aws_networkfirewall_firewall.this[0].arn, null)
}

output "status" {
  description = "Nested list of information about the current status of the firewall"
  value       = try(aws_networkfirewall_firewall.this[0].firewall_status, null)
}

output "update_token" {
  description = "A string token used when updating a firewall"
  value       = try(aws_networkfirewall_firewall.this[0].update_token, null)
}

################################################################################
# Firewall Logging Configuration
################################################################################

output "logging_configuration_id" {
  description = "The Amazon Resource Name (ARN) of the associated firewall"
  value       = try(aws_networkfirewall_logging_configuration.this[0].id, null)
}
