module "wrapper" {
  source = "../../modules/rule-group"

  for_each = var.items

  create                     = try(each.value.create, var.defaults.create, true)
  tags                       = try(each.value.tags, var.defaults.tags, {})
  capacity                   = try(each.value.capacity, var.defaults.capacity, 100)
  description                = try(each.value.description, var.defaults.description, null)
  encryption_configuration   = try(each.value.encryption_configuration, var.defaults.encryption_configuration, {})
  name                       = try(each.value.name, var.defaults.name, "")
  rule_group                 = try(each.value.rule_group, var.defaults.rule_group, {})
  rules                      = try(each.value.rules, var.defaults.rules, null)
  type                       = try(each.value.type, var.defaults.type, "STATELESS")
  create_resource_policy     = try(each.value.create_resource_policy, var.defaults.create_resource_policy, false)
  resource_policy_actions    = try(each.value.resource_policy_actions, var.defaults.resource_policy_actions, [])
  resource_policy_principals = try(each.value.resource_policy_principals, var.defaults.resource_policy_principals, [])
  attach_resource_policy     = try(each.value.attach_resource_policy, var.defaults.attach_resource_policy, false)
  resource_policy            = try(each.value.resource_policy, var.defaults.resource_policy, "")
  ram_resource_associations  = try(each.value.ram_resource_associations, var.defaults.ram_resource_associations, {})
}
