################################################################################
# Network Firewall
################################################################################

module "firewall" {
  source = "./modules/firewall"

  create = var.create
  region = var.region

  # Firewall
  availability_zone_change_protection = var.availability_zone_change_protection
  availability_zone_mapping           = var.availability_zone_mapping
  delete_protection                   = var.delete_protection
  description                         = var.description
  enabled_analysis_types              = var.enabled_analysis_types
  encryption_configuration            = var.encryption_configuration
  firewall_policy_arn                 = var.create_policy ? module.policy.arn : var.firewall_policy_arn
  firewall_policy_change_protection   = var.firewall_policy_change_protection
  name                                = var.name
  subnet_change_protection            = var.subnet_change_protection
  subnet_mapping                      = var.subnet_mapping
  transit_gateway_id                  = var.transit_gateway_id
  vpc_id                              = var.vpc_id

  # Logging
  create_logging_configuration             = var.create_logging_configuration
  logging_configuration_destination_config = var.logging_configuration_destination_config
  enable_monitoring_dashboard              = var.enable_monitoring_dashboard

  tags = var.tags
}

################################################################################
# Policy
################################################################################

module "policy" {
  source = "./modules/policy"

  create = var.create && var.create_policy
  region = var.region

  # Policy
  description                        = var.policy_description
  encryption_configuration           = var.policy_encryption_configuration
  policy_variables                   = var.policy_variables
  stateful_default_actions           = var.policy_stateful_default_actions
  stateful_engine_options            = var.policy_stateful_engine_options
  stateful_rule_group_reference      = var.policy_stateful_rule_group_reference
  stateless_custom_action            = var.policy_stateless_custom_action
  stateless_default_actions          = var.policy_stateless_default_actions
  stateless_fragment_default_actions = var.policy_stateless_fragment_default_actions
  stateless_rule_group_reference     = var.policy_stateless_rule_group_reference
  name                               = try(coalesce(var.policy_name, var.name), "")

  # TLS Inspection
  tls_inspection_configuration_arn = var.policy_tls_inspection_configuration_arn
  enable_tls_session_holding       = var.policy_enable_tls_session_holding

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

################################################################################
# Routing
#
# A firewall only inspects traffic that is routed through it, and working out those
# routes means knowing which endpoint serves which availability zone. That mapping is
# only available inside the firewall's status, so callers otherwise have to reach into
# the raw resource shape to build it themselves
################################################################################

locals {
  # Availability zone to firewall endpoint. Values are only known after apply, so this
  # is used to look endpoints up, never to decide how many resources to create
  endpoints = {
    for state in flatten(try(module.firewall.status[*].sync_states, [])) :
    state.availability_zone => state.attachment[0].endpoint_id
  }

  single_vpc           = try(var.routing_configuration.single_vpc, null)
  intra_vpc_inspection = try(var.routing_configuration.intra_vpc_inspection, null)
}

# Traffic leaving a protected subnet reaches the firewall in its own availability zone
resource "aws_route" "protected_subnet_to_firewall" {
  for_each = { for az, rt in try(local.single_vpc.protected_subnet_route_tables, {}) : az => rt if var.create }

  region = var.region

  route_table_id         = each.value
  destination_cidr_block = local.single_vpc.destination_cidr_block
  vpc_endpoint_id        = local.endpoints[each.key]
}

# Traffic arriving from the internet reaches the firewall before the protected subnet.
# Without this the firewall sees only one direction of each flow, which a stateful engine
# cannot evaluate, and nothing about the configuration looks wrong
resource "aws_route" "igw_to_firewall" {
  for_each = { for az, cidr in try(local.single_vpc.protected_subnet_cidr_blocks, {}) : az => cidr if var.create && try(local.single_vpc.igw_route_table, null) != null }

  region = var.region

  route_table_id         = local.single_vpc.igw_route_table
  destination_cidr_block = each.value
  vpc_endpoint_id        = local.endpoints[each.key]
}

# Traffic between two subnets in the same VPC, sent through the firewall by a route more
# specific than the local route
resource "aws_route" "intra_vpc_inspection" {
  for_each = { for k, v in try(local.intra_vpc_inspection.routes, {}) : k => v if var.create }

  region = var.region

  route_table_id              = each.value.route_table_id
  destination_cidr_block      = each.value.destination_ipv4_cidr_block
  destination_ipv6_cidr_block = each.value.destination_ipv6_cidr_block
  vpc_endpoint_id             = local.endpoints[each.value.availability_zone]
}
