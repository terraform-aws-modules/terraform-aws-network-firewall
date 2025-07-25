variable "create" {
  description = "Controls if resources should be created"
  type        = bool
  default     = true
  nullable    = false
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
# Firewall Policy
################################################################################

variable "description" {
  description = "A friendly description of the firewall policy"
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

variable "policy_variables" {
  description = "Contains variables that you can use to override default Suricata settings in your firewall policy"
  type = object({
    rule_variables = list(object({
      ip_set = optional(object({
        definition = list(string)
      }))
      key = string
    }))
  })
  default = null
}

variable "stateful_default_actions" {
  description = "Set of actions to take on a packet if it does not match any stateful rules in the policy. This can only be specified if the policy has a `stateful_engine_options` block with a rule_order value of `STRICT_ORDER`. You can specify one of either or neither values of `aws:drop_strict` or `aws:drop_established`, as well as any combination of `aws:alert_strict` and `aws:alert_established`"
  type        = list(string)
  default     = []
  nullable    = false
}

variable "stateful_engine_options" {
  description = "A configuration block that defines options on how the policy handles stateful rules. See [Stateful Engine Options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy#stateful-engine-options) for details"
  type = object({
    flow_timeouts = optional(object({
      tcp_idle_timeout_seconds = optional(number)
    }))
    rule_order              = optional(string)
    stream_exception_policy = optional(string)
  })
  default = null
}

variable "stateful_rule_group_reference" {
  description = "Set of configuration blocks containing references to the stateful rule groups that are used in the policy. See [Stateful Rule Group Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy#stateful-rule-group-reference) for details"
  type = map(object({
    deep_threat_inspection = optional(bool)
    override = optional(object({
      action = optional(string)
    }))
    priority     = optional(number)
    resource_arn = string
  }))
  default = null
}

variable "stateless_custom_action" {
  description = "Set of configuration blocks describing the custom action definitions that are available for use in the firewall policy's `stateless_default_actions`"
  type = map(object({
    action_definition = object({
      publish_metric_action = optional(object({
        dimension = optional(string)
      }))
    })
    action_name = string
  }))
  default = null
}

variable "stateless_default_actions" {
  description = "Set of actions to take on a packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: `aws:drop`, `aws:pass`, or `aws:forward_to_sfe`"
  type        = list(string)
  default     = ["aws:pass"]
  nullable    = false
}

variable "stateless_fragment_default_actions" {
  description = "Set of actions to take on a fragmented packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: `aws:drop`, `aws:pass`, or `aws:forward_to_sfe`"
  type        = list(string)
  default     = ["aws:pass"]
  nullable    = false
}

variable "stateless_rule_group_reference" {
  description = "Set of configuration blocks containing references to the stateless rule groups that are used in the policy. See [Stateless Rule Group Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy#stateless-rule-group-reference) for details"
  type = map(object({
    priority     = number
    resource_arn = string
  }))
  default = null
}

variable "name" {
  description = "A friendly name of the firewall policy"
  type        = string
  default     = ""
}

################################################################################
# Resource Policies
################################################################################

variable "create_resource_policy" {
  description = "Controls if a resource policy should be created"
  type        = bool
  default     = false
  nullable    = false
}

variable "resource_policy_actions" {
  description = "A list of IAM actions allowed in the resource policy"
  type        = list(string)
  default     = []
  nullable    = false
}

variable "resource_policy_principals" {
  description = "A list of IAM principals allowed in the resource policy"
  type        = list(string)
  default     = []
  nullable    = false
}

variable "attach_resource_policy" {
  description = "Controls if a resource policy should be attached to the firewall policy"
  type        = bool
  default     = false
  nullable    = false
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
  description = "A map of RAM resource associations for the created firewall policy"
  type        = map(string)
  default     = {}
  nullable    = false
}
