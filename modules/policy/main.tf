################################################################################
# Firewall Policy
################################################################################

resource "aws_networkfirewall_firewall_policy" "this" {
  count = var.create ? 1 : 0

  region = var.region

  description = var.description

  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration != null ? [var.encryption_configuration] : []

    content {
      key_id = encryption_configuration.value.key_id
      type   = encryption_configuration.value.type
    }
  }

  firewall_policy {
    dynamic "policy_variables" {
      for_each = var.policy_variables != null ? [var.policy_variables] : []

      content {
        dynamic "rule_variables" {
          for_each = policy_variables.value.rule_variables != null ? policy_variables.value.rule_variables : []

          content {
            dynamic "ip_set" {
              for_each = rule_variables.value.ip_set != null ? [rule_variables.value.ip_set] : []

              content {
                definition = ip_set.value.definition
              }
            }

            key = rule_variables.value.key
          }
        }
      }
    }

    # Stateful
    stateful_default_actions = var.stateful_default_actions

    dynamic "stateful_engine_options" {
      for_each = var.stateful_engine_options != null ? [var.stateful_engine_options] : []

      content {
        dynamic "flow_timeouts" {
          for_each = stateful_engine_options.value.flow_timeouts != null ? [stateful_engine_options.value.flow_timeouts] : []

          content {
            tcp_idle_timeout_seconds = flow_timeouts.value.tcp_idle_timeout_seconds
          }
        }

        rule_order              = stateful_engine_options.value.rule_order
        stream_exception_policy = stateful_engine_options.value.stream_exception_policy
      }
    }

    dynamic "stateful_rule_group_reference" {
      for_each = var.stateful_rule_group_reference != null ? var.stateful_rule_group_reference : {}

      content {
        deep_threat_inspection = stateful_rule_group_reference.value.deep_threat_inspection

        dynamic "override" {
          for_each = stateful_rule_group_reference.value.override != null ? [stateful_rule_group_reference.value.override] : []

          content {
            action = override.value.action
          }
        }

        priority     = stateful_rule_group_reference.value.priority
        resource_arn = stateful_rule_group_reference.value.resource_arn
      }
    }

    # Stateless
    dynamic "stateless_custom_action" {
      for_each = var.stateless_custom_action != null ? var.stateless_custom_action : {}

      content {
        dynamic "action_definition" {
          for_each = stateless_custom_action.value.action_definition

          content {
            dynamic "publish_metric_action" {
              for_each = action_definition.value.publish_metric_action

              content {
                dynamic "dimension" {
                  for_each = publish_metric_action.value.dimension

                  content {
                    value = dimension.value.value
                  }
                }
              }
            }
          }
        }

        action_name = stateless_custom_action.value.action_name
      }
    }

    stateless_default_actions          = var.stateless_default_actions
    stateless_fragment_default_actions = var.stateless_fragment_default_actions

    dynamic "stateless_rule_group_reference" {
      for_each = var.stateless_rule_group_reference != null ? var.stateless_rule_group_reference : {}

      content {
        priority     = stateless_rule_group_reference.value.priority
        resource_arn = stateless_rule_group_reference.value.resource_arn
      }
    }
  }

  name = var.name

  tags = var.tags
}

################################################################################
# Resource Policy
################################################################################

data "aws_iam_policy_document" "firewall_policy" {
  count = var.create && var.create_resource_policy ? 1 : 0

  statement {
    sid = "NetworkFirewallResourcePolicy"
    actions = distinct(concat(
      var.resource_policy_actions,
      # policy must include the following operations
      [
        "network-firewall:ListFirewallPolicies",
        "network-firewall:CreateFirewall",
        "network-firewall:UpdateFirewall",
        "network-firewall:AssociateFirewallPolicy",
      ]
    ))
    resources = [aws_networkfirewall_firewall_policy.this[0].arn]

    principals {
      type        = "AWS"
      identifiers = var.resource_policy_principals
    }
  }
}

resource "aws_networkfirewall_resource_policy" "this" {
  count = var.create && var.attach_resource_policy ? 1 : 0

  region = var.region

  resource_arn = aws_networkfirewall_firewall_policy.this[0].arn
  policy       = var.create_resource_policy ? data.aws_iam_policy_document.firewall_policy[0].json : var.resource_policy
}

################################################################################
# RAM Resource Association
################################################################################

resource "aws_ram_resource_association" "firewall_policy" {
  for_each = { for k, v in var.ram_resource_associations : k => v if var.create }

  region = var.region

  resource_arn       = aws_networkfirewall_firewall_policy.this[0].arn
  resource_share_arn = each.value.resource_share_arn
}
