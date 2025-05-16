################################################################################
# Network Firewall
################################################################################

module "firewall" {
  source = "./modules/firewall"

  create = var.create

  # Firewall
  delete_protection                 = var.delete_protection
  description                       = var.description
  enabled_type_analysis             = var.enabled_analysis_types
  encryption_configuration          = var.encryption_configuration
  firewall_policy_arn               = var.create_policy ? module.policy.arn : var.firewall_policy_arn
  firewall_policy_change_protection = var.firewall_policy_change_protection
  name                              = var.name
  subnet_change_protection          = var.subnet_change_protection
  subnet_mapping                    = var.subnet_mapping
  vpc_id                            = var.vpc_id

  # Logging
  create_logging_configuration             = var.create_logging_configuration
  logging_configuration_destination_config = var.logging_configuration_destination_config

  tags = var.tags
}

################################################################################
# Policy
################################################################################

module "policy" {
  source = "./modules/policy"

  create = var.create && var.create_policy

  # Policy
  description                        = var.policy_description
  encryption_configuration           = var.policy_encryption_configuration
  stateful_default_actions           = var.policy_stateful_default_actions
  stateful_engine_options            = var.policy_stateful_engine_options
  stateful_rule_group_reference      = var.policy_stateful_rule_group_reference
  stateless_custom_action            = var.policy_stateless_custom_action
  stateless_default_actions          = var.policy_stateless_default_actions
  stateless_fragment_default_actions = var.policy_stateless_fragment_default_actions
  stateless_rule_group_reference     = var.policy_stateless_rule_group_reference
  name                               = try(coalesce(var.policy_name, var.name), "")

  # Resource policy
  create_resource_policy     = var.create_policy_resource_policy
  resource_policy_actions    = var.policy_resource_policy_actions
  resource_policy_principals = var.policy_resource_policy_principals
  attach_resource_policy     = var.policy_attach_resource_policy
  resource_policy            = var.policy_resource_policy

  # RAM resource association
  ram_resource_associations = var.policy_ram_resource_associations

  tags = merge(var.tags, var.policy_tags)
}
