module "wrapper" {
  source = "../../modules/policy"

  for_each = var.items

  create                             = try(each.value.create, var.defaults.create, true)
  tags                               = try(each.value.tags, var.defaults.tags, {})
  description                        = try(each.value.description, var.defaults.description, null)
  encryption_configuration           = try(each.value.encryption_configuration, var.defaults.encryption_configuration, {})
  stateful_default_actions           = try(each.value.stateful_default_actions, var.defaults.stateful_default_actions, [])
  stateful_engine_options            = try(each.value.stateful_engine_options, var.defaults.stateful_engine_options, {})
  stateful_rule_group_reference      = try(each.value.stateful_rule_group_reference, var.defaults.stateful_rule_group_reference, {})
  stateless_custom_action            = try(each.value.stateless_custom_action, var.defaults.stateless_custom_action, {})
  stateless_default_actions          = try(each.value.stateless_default_actions, var.defaults.stateless_default_actions, ["aws:pass"])
  stateless_fragment_default_actions = try(each.value.stateless_fragment_default_actions, var.defaults.stateless_fragment_default_actions, ["aws:pass"])
  stateless_rule_group_reference     = try(each.value.stateless_rule_group_reference, var.defaults.stateless_rule_group_reference, {})
  name                               = try(each.value.name, var.defaults.name, "")
  create_resource_policy             = try(each.value.create_resource_policy, var.defaults.create_resource_policy, false)
  resource_policy_actions            = try(each.value.resource_policy_actions, var.defaults.resource_policy_actions, [])
  resource_policy_principals         = try(each.value.resource_policy_principals, var.defaults.resource_policy_principals, [])
  attach_resource_policy             = try(each.value.attach_resource_policy, var.defaults.attach_resource_policy, false)
  resource_policy                    = try(each.value.resource_policy, var.defaults.resource_policy, "")
  ram_resource_associations          = try(each.value.ram_resource_associations, var.defaults.ram_resource_associations, {})
}
