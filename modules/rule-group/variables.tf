variable "create" {
  description = "Controls if Network Firewall resources should be created"
  type        = bool
  default     = true
}

variable "region" {
  description = "Region where the resource(s) will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Rule Group
################################################################################

variable "capacity" {
  description = "The maximum number of operating resources that this rule group can use. For a stateless rule group, the capacity required is the sum of the capacity requirements of the individual rules. For a stateful rule group, the minimum capacity required is the number of individual rules"
  type        = number
  default     = 100
}

variable "description" {
  description = "A friendly description of the rule group"
  type        = string
  default     = null
}

variable "encryption_configuration" {
  description = "KMS encryption configuration settings"
  type = object({
    key_id = optional(string)
    type   = string
  })
  default = null
}

variable "name" {
  description = "A friendly name of the rule group"
  type        = string
  default     = ""
}

variable "rule_group" {
  description = "A configuration block that defines the rule group rules. Required unless `rules` is specified"
  type = object({
    reference_sets = optional(object({
      ip_set_references = optional(map(object({
        reference_arn = string
      })))
      key = string
    }))
    rules_source = optional(object({
      rules_source_list = optional(object({
        generated_rules_type = string
        target_types         = list(string)
        targets              = list(string)
      }))
      rules_string = optional(string)
      stateful_rule = optional(list(object({
        action = string
        header = object({
          destination      = string
          destination_port = string
          direction        = string
          protocol         = string
          source           = string
          source_port      = string
        })
        rule_option = list(object({
          keyword  = string
          settings = optional(list(string))
        }))
      })))
      stateless_rules_and_custom_actions = optional(object({
        custom_action = optional(list(object({
          action_definition = object({
            publish_metric_action = object({
              dimension = list(object({
                value = string
              }))
            })
          })
          action_name = string
        })))
        stateless_rule = list(object({
          priority = number
          rule_definition = object({
            actions = list(string)
            match_attributes = object({
              destination = optional(list(object({
                address_definition = string
              })))
              destination_port = optional(list(object({
                from_port = string
                to_port   = optional(string)
              })))
              protocols = optional(list(string))
              source = optional(list(object({
                address_definition = string
              })))
              source_port = optional(list(object({
                from_port = string
                to_port   = optional(string)
              })))
              tcp_flag = optional(list(object({
                flags = list(string)
                masks = optional(list(string))
              })))
            })
          })
          rule_options = optional(list(object({
            keyword  = string
            settings = optional(list(string))
          })))
        }))
      }))
    }))
    rule_variables = optional(object({
      ip_sets = optional(list(object({
        key = string
        ip_set = object({
          definition = list(string)
        })
      })))
      port_sets = optional(list(object({
        key = string
        port_set = object({
          definition = list(string)
        })
      })))
    }))
    stateful_rule_options = optional(object({
      rule_order = optional(string)
    }))
  })

  default = null
}

variable "rules" {
  description = "The stateful rule group rules specifications in Suricata file format, with one rule per line. Use this to import your existing Suricata compatible rule groups. Required unless `rule_group` is specified"
  type        = string
  default     = null
}

variable "type" {
  description = "Whether the rule group is stateless (containing stateless rules) or stateful (containing stateful rules). Valid values include: `STATEFUL` or `STATELESS`"
  type        = string
  default     = "STATELESS"
}

################################################################################
# Resource Policy
################################################################################

variable "create_resource_policy" {
  description = "Controls if a resource policy should be created"
  type        = bool
  default     = false
}

variable "resource_policy_actions" {
  description = "A list of IAM actions allowed in the resource policy"
  type        = list(string)
  default     = []
}

variable "resource_policy_principals" {
  description = "A list of IAM principals allowed in the resource policy"
  type        = list(string)
  default     = []
}

variable "attach_resource_policy" {
  description = "Controls if a resource policy should be attached to the rule group"
  type        = bool
  default     = false
}

variable "resource_policy" {
  description = "The policy JSON to use for the resource policy; required when `create_resource_policy` is `false`"
  type        = string
  default     = ""
}

################################################################################
# RAM Resource Association
################################################################################

variable "ram_resource_associations" {
  description = "A map of RAM resource associations for the created rule group"
  type        = map(string)
  default     = {}
}
