################################################################################
# Rule Group
################################################################################

resource "aws_networkfirewall_rule_group" "this" {
  count = var.create ? 1 : 0

  region = var.region

  capacity    = var.capacity
  description = var.description

  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration != null ? [var.encryption_configuration] : []

    content {
      key_id = encryption_configuration.value.key_id
      type   = encryption_configuration.value.type
    }
  }

  name = var.name

  dynamic "rule_group" {
    for_each = var.rule_group != null ? [var.rule_group] : []

    content {
      dynamic "reference_sets" {
        for_each = rule_group.value.reference_sets != null ? [rule_group.value.reference_sets] : []

        content {
          dynamic "ip_set_references" {
            for_each = reference_sets.value.ip_set_references != null ? reference_sets.value.ip_set_references : {}

            content {
              dynamic "ip_set_reference" {
                for_each = ip_set_references.value != null ? ip_set_references.value : []

                content {
                  reference_arn = ip_set_reference.value.reference_arn
                }
              }

              key = ip_set_references.value.key
            }
          }
        }
      }

      dynamic "rules_source" {
        for_each = rule_group.value.rules_source != null ? [rule_group.value.rules_source] : []

        content {
          dynamic "rules_source_list" {
            for_each = rules_source.value.rules_source_list != null ? [rules_source.value.rules_source_list] : []

            content {
              generated_rules_type = rules_source_list.value.generated_rules_type
              target_types         = rules_source_list.value.target_types
              targets              = rules_source_list.value.targets
            }
          }

          rules_string = try(rules_source.value.rules_string, null)

          dynamic "stateful_rule" {
            # One or more
            for_each = rules_source.value.stateful_rule != null ? rules_source.value.stateful_rule : []

            content {
              action = stateful_rule.value.action

              dynamic "header" {
                for_each = stateful_rule.value.header != null ? [stateful_rule.value.header] : []

                content {
                  destination      = header.value.destination
                  destination_port = header.value.destination_port
                  direction        = header.value.direction
                  protocol         = header.value.protocol
                  source           = header.value.source
                  source_port      = header.value.source_port
                }
              }

              dynamic "rule_option" {
                # One or more
                for_each = stateful_rule.value.rule_option != null ? stateful_rule.value.rule_option : []

                content {
                  keyword  = rule_option.value.keyword
                  settings = rule_option.value.settings
                }
              }
            }
          }

          dynamic "stateless_rules_and_custom_actions" {
            for_each = rules_source.value.stateless_rules_and_custom_actions != null ? [rules_source.value.stateless_rules_and_custom_actions] : []

            content {
              dynamic "custom_action" {
                # One or more
                for_each = stateless_rules_and_custom_actions.value.custom_action != null ? stateless_rules_and_custom_actions.value.custom_action : []

                content {
                  dynamic "action_definition" {
                    for_each = custom_action.value.action_definition != null ? [custom_action.value.action_definition] : []

                    content {
                      dynamic "publish_metric_action" {
                        for_each = action_definition.value.publish_metric_action != null ? [action_definition.value.publish_metric_action] : []

                        content {
                          dynamic "dimension" {
                            # One or more
                            for_each = publish_metric_action.value.dimension != null ? publish_metric_action.value.dimension : []

                            content {
                              value = dimension.value.value
                            }
                          }
                        }
                      }
                    }
                  }

                  action_name = custom_action.value.action_name
                }
              }

              dynamic "stateless_rule" {
                # One or more
                for_each = stateless_rules_and_custom_actions.value.stateless_rule != null ? stateless_rules_and_custom_actions.value.stateless_rule : []

                content {
                  priority = stateless_rule.value.priority

                  dynamic "rule_definition" {
                    for_each = stateless_rule.value.rule_definition != null ? [stateless_rule.value.rule_definition] : []

                    content {
                      actions = rule_definition.value.actions

                      dynamic "match_attributes" {
                        for_each = rule_definition.value.match_attributes != null ? [rule_definition.value.match_attributes] : []

                        content {
                          dynamic "destination" {
                            # One or more
                            for_each = match_attributes.value.destination != null ? match_attributes.value.destination : []

                            content {
                              address_definition = destination.value.address_definition
                            }
                          }

                          dynamic "destination_port" {
                            # One or more
                            for_each = match_attributes.value.destination_port != null ? match_attributes.value.destination_port : []

                            content {
                              from_port = destination_port.value.from_port
                              to_port   = destination_port.value.to_port
                            }
                          }

                          protocols = match_attributes.value.protocols

                          dynamic "source" {
                            # One or more
                            for_each = match_attributes.value.source != null ? match_attributes.value.source : []

                            content {
                              address_definition = source.value.address_definition
                            }
                          }

                          dynamic "source_port" {
                            # One or more
                            for_each = match_attributes.value.source_port != null ? match_attributes.value.source_port : []

                            content {
                              from_port = source_port.value.from_port
                              to_port   = source_port.value.to_port
                            }
                          }

                          dynamic "tcp_flag" {
                            # One or more
                            for_each = match_attributes.value.tcp_flag != null ? match_attributes.value.tcp_flag : []

                            content {
                              flags = tcp_flag.value.flags
                              masks = tcp_flag.value.masks
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "rule_variables" {
        for_each = rule_group.value.rule_variables != null ? [rule_group.value.rule_variables] : []

        content {
          dynamic "ip_sets" {
            # One or more
            for_each = rule_variables.value.ip_sets != null ? rule_variables.value.ip_sets : []

            content {
              key = ip_sets.value.key

              dynamic "ip_set" {
                for_each = ip_sets.value.ip_set != null ? [ip_sets.value.ip_set] : []

                content {
                  definition = ip_set.value.definition
                }
              }
            }
          }

          dynamic "port_sets" {
            # One or more
            for_each = rule_variables.value.port_sets != null ? rule_variables.value.port_sets : []

            content {
              key = port_sets.value.key

              dynamic "port_set" {
                for_each = [port_sets.value.port_set]

                content {
                  definition = port_set.value.definition
                }
              }
            }
          }
        }
      }

      dynamic "stateful_rule_options" {
        for_each = rule_group.value.stateful_rule_options != null ? [rule_group.value.stateful_rule_options] : []

        content {
          rule_order = stateful_rule_options.value.rule_order
        }
      }
    }
  }

  rules = var.rules
  type  = var.type

  tags = var.tags
}

################################################################################
# Resource Policy
################################################################################

data "aws_iam_policy_document" "rule_group" {
  count = var.create && var.create_resource_policy ? 1 : 0

  statement {
    sid = "RuleGroupResourcePolicy"
    actions = distinct(concat(
      var.resource_policy_actions,
      [
        "network-firewall:ListRuleGroups",
        "network-firewall:CreateFirewallPolicy",
        "network-firewall:UpdateFirewallPolicy",
      ]
    ))
    resources = [aws_networkfirewall_rule_group.this[0].arn]

    principals {
      type        = "AWS"
      identifiers = var.resource_policy_principals
    }
  }
}

resource "aws_networkfirewall_resource_policy" "this" {
  count = var.create && var.attach_resource_policy ? 1 : 0

  region = var.region

  resource_arn = aws_networkfirewall_rule_group.this[0].arn
  policy       = var.create_resource_policy ? data.aws_iam_policy_document.rule_group[0].json : var.resource_policy
}

################################################################################
# RAM Resource Association
################################################################################

resource "aws_ram_resource_association" "this" {
  for_each = { for k, v in var.ram_resource_associations : k => v if var.create }

  region = var.region

  resource_arn       = aws_networkfirewall_rule_group.this[0].arn
  resource_share_arn = each.value.resource_share_arn
}
