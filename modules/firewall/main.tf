################################################################################
# Firewall
################################################################################

resource "aws_networkfirewall_firewall" "this" {
  count = var.create ? 1 : 0

  region = var.region

  availability_zone_change_protection = var.availability_zone_change_protection

  dynamic "availability_zone_mapping" {
    for_each = var.availability_zone_mapping != null ? var.availability_zone_mapping : []

    content {
      availability_zone_id = availability_zone_mapping.value.availability_zone_id
    }
  }

  delete_protection      = var.delete_protection
  description            = var.description
  enabled_analysis_types = var.enabled_analysis_types

  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration != null ? [var.encryption_configuration] : []

    content {
      key_id = encryption_configuration.value.key_id
      type   = encryption_configuration.value.type
    }
  }

  firewall_policy_arn               = var.firewall_policy_arn
  firewall_policy_change_protection = var.firewall_policy_change_protection
  name                              = var.name
  subnet_change_protection          = var.subnet_change_protection

  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping != null ? var.subnet_mapping : {}

    content {
      ip_address_type = subnet_mapping.value.ip_address_type
      subnet_id       = subnet_mapping.value.subnet_id
    }
  }

  transit_gateway_id = var.transit_gateway_id
  vpc_id             = var.vpc_id

  tags = var.tags
}

################################################################################
# Logging Configuration
################################################################################

resource "aws_networkfirewall_logging_configuration" "this" {
  count = var.create && var.create_logging_configuration ? 1 : 0

  region = var.region

  firewall_arn = aws_networkfirewall_firewall.this[0].arn

  logging_configuration {
    # At least one config, at most, only two blocks can be specified; one for `FLOW` logs and one for `ALERT` logs.
    dynamic "log_destination_config" {
      for_each = var.logging_configuration_destination_config != null ? var.logging_configuration_destination_config : []

      content {
        log_destination      = log_destination_config.value.log_destination
        log_destination_type = log_destination_config.value.log_destination_type
        log_type             = log_destination_config.value.log_type
      }
    }
  }
}
