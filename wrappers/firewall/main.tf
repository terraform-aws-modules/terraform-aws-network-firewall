module "wrapper" {
  source = "../../modules/firewall"

  for_each = var.items

  create                                   = try(each.value.create, var.defaults.create, true)
  tags                                     = try(each.value.tags, var.defaults.tags, {})
  delete_protection                        = try(each.value.delete_protection, var.defaults.delete_protection, true)
  description                              = try(each.value.description, var.defaults.description, "")
  encryption_configuration                 = try(each.value.encryption_configuration, var.defaults.encryption_configuration, {})
  firewall_policy_arn                      = try(each.value.firewall_policy_arn, var.defaults.firewall_policy_arn, "")
  firewall_policy_change_protection        = try(each.value.firewall_policy_change_protection, var.defaults.firewall_policy_change_protection, null)
  name                                     = try(each.value.name, var.defaults.name, "")
  subnet_change_protection                 = try(each.value.subnet_change_protection, var.defaults.subnet_change_protection, true)
  subnet_mapping                           = try(each.value.subnet_mapping, var.defaults.subnet_mapping, {})
  vpc_id                                   = try(each.value.vpc_id, var.defaults.vpc_id, "")
  create_logging_configuration             = try(each.value.create_logging_configuration, var.defaults.create_logging_configuration, false)
  logging_configuration_destination_config = try(each.value.logging_configuration_destination_config, var.defaults.logging_configuration_destination_config, [])
}
