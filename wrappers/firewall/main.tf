module "wrapper" {
  source = "../../modules/firewall"

  for_each = var.items

  availability_zone_change_protection      = try(each.value.availability_zone_change_protection, var.defaults.availability_zone_change_protection, null)
  availability_zone_mapping                = try(each.value.availability_zone_mapping, var.defaults.availability_zone_mapping, null)
  create                                   = try(each.value.create, var.defaults.create, true)
  create_logging_configuration             = try(each.value.create_logging_configuration, var.defaults.create_logging_configuration, false)
  delete_protection                        = try(each.value.delete_protection, var.defaults.delete_protection, true)
  description                              = try(each.value.description, var.defaults.description, null)
  enabled_analysis_types                   = try(each.value.enabled_analysis_types, var.defaults.enabled_analysis_types, [])
  encryption_configuration                 = try(each.value.encryption_configuration, var.defaults.encryption_configuration, null)
  firewall_policy_arn                      = try(each.value.firewall_policy_arn, var.defaults.firewall_policy_arn, "")
  firewall_policy_change_protection        = try(each.value.firewall_policy_change_protection, var.defaults.firewall_policy_change_protection, null)
  logging_configuration_destination_config = try(each.value.logging_configuration_destination_config, var.defaults.logging_configuration_destination_config, null)
  name                                     = try(each.value.name, var.defaults.name, "")
  region                                   = try(each.value.region, var.defaults.region, null)
  subnet_change_protection                 = try(each.value.subnet_change_protection, var.defaults.subnet_change_protection, true)
  subnet_mapping                           = try(each.value.subnet_mapping, var.defaults.subnet_mapping, null)
  tags                                     = try(each.value.tags, var.defaults.tags, {})
  transit_gateway_id                       = try(each.value.transit_gateway_id, var.defaults.transit_gateway_id, null)
  vpc_id                                   = try(each.value.vpc_id, var.defaults.vpc_id, null)
}
