variable "create" {
  description = "Controls if resources should be created"
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
# Firewall
################################################################################

variable "availability_zone_change_protection" {
  description = " A setting indicating whether the firewall is protected against changes to its Availability Zone configuration. When set to true, you must first disable this protection before adding or removing Availability Zones"
  type        = bool
  default     = null
}

variable "availability_zone_mapping" {
  description = "Required when creating a transit gateway-attached firewall. Set of configuration blocks describing the avaiability availability where you want to create firewall endpoints for a transit gateway-attached firewall"
  type = list(object({
    availability_zone_id = string
  }))
  default = null
}

variable "delete_protection" {
  description = "A boolean flag indicating whether it is possible to delete the firewall. Defaults to `true`"
  type        = bool
  default     = true
}

variable "description" {
  description = "A friendly description of the firewall"
  type        = string
  default     = ""
}

variable "enabled_analysis_types" {
  description = "Set of types for which to collect analysis metrics. Valid values: `TLS_SNI`, `HTTP_HOST`. Defaults to `[]`"
  type        = list(string)
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

variable "firewall_policy_arn" {
  description = "The ARN of the Firewall Policy to use"
  type        = string
  default     = ""
}

variable "firewall_policy_change_protection" {
  description = "A boolean flag indicating whether it is possible to change the associated firewall policy. Defaults to `false`"
  type        = bool
  default     = null
}

variable "name" {
  description = "A friendly name of the firewall"
  type        = string
  default     = ""
}

variable "subnet_change_protection" {
  description = "A boolean flag indicating whether it is possible to change the associated subnet(s). Defaults to `true`"
  type        = bool
  default     = true
}

variable "subnet_mapping" {
  description = "Set of configuration blocks describing the public subnets. Each subnet must belong to a different Availability Zone in the VPC. AWS Network Firewall creates a firewall endpoint in each subnet"
  type = map(object({
    ip_address_type = optional(string)
    subnet_id       = string
  }))
  default = null
}

variable "transit_gateway_id" {
  description = "The ID of the transit gateway to which the firewall is attached. Required when creating a transit gateway-attached firewall"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The unique identifier of the VPC where AWS Network Firewall should create the firewall"
  type        = string
  default     = null
}

################################################################################
# Firewall Logging Configuration
################################################################################

variable "create_logging_configuration" {
  description = "Controls if a Logging Configuration should be created"
  type        = bool
  default     = null
}

variable "logging_configuration_destination_config" {
  description = "A list of min 1, max 2 configuration blocks describing the destination for the logging configuration"
  type = list(object({
    log_destination      = map(string)
    log_destination_type = string
    log_type             = string
  }))
  default = null
}

################################################################################
# Firewall Policy
################################################################################

variable "create_policy" {
  description = "Controls if policy should be created"
  type        = bool
  default     = true
}

variable "policy_description" {
  description = "A friendly description of the firewall policy"
  type        = string
  default     = null
}

variable "policy_encryption_configuration" {
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

variable "policy_stateful_default_actions" {
  description = "Set of actions to take on a packet if it does not match any stateful rules in the policy. This can only be specified if the policy has a `stateful_engine_options` block with a rule_order value of `STRICT_ORDER`. You can specify one of either or neither values of `aws:drop_strict` or `aws:drop_established`, as well as any combination of `aws:alert_strict` and `aws:alert_established`"
  type        = list(string)
  default     = null
}

variable "policy_stateful_engine_options" {
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

variable "policy_stateful_rule_group_reference" {
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

variable "policy_stateless_custom_action" {
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

variable "policy_stateless_default_actions" {
  description = "Set of actions to take on a packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: `aws:drop`, `aws:pass`, or `aws:forward_to_sfe`"
  type        = list(string)
  default     = null
}

variable "policy_stateless_fragment_default_actions" {
  description = "Set of actions to take on a fragmented packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: `aws:drop`, `aws:pass`, or `aws:forward_to_sfe`"
  type        = list(string)
  default     = null
}

variable "policy_stateless_rule_group_reference" {
  description = "Set of configuration blocks containing references to the stateless rule groups that are used in the policy. See [Stateless Rule Group Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy#stateless-rule-group-reference) for details"
  type = map(object({
    priority     = number
    resource_arn = string
  }))
  default = null
}

variable "policy_name" {
  description = "A friendly name of the firewall policy"
  type        = string
  default     = ""
}

variable "policy_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

# Resource Policy
variable "create_policy_resource_policy" {
  description = "Controls if a resource policy should be created"
  type        = bool
  default     = null
}

variable "policy_resource_policy_actions" {
  description = "A list of IAM actions allowed in the resource policy"
  type        = list(string)
  default     = null
}

variable "policy_resource_policy_principals" {
  description = "A list of IAM principals allowed in the resource policy"
  type        = list(string)
  default     = null
}

variable "policy_attach_resource_policy" {
  description = "Controls if a resource policy should be attached to the firewall policy"
  type        = bool
  default     = null
}

variable "policy_resource_policy" {
  description = "The policy JSON to use for the resource policy; required when `create_resource_policy` is `false`"
  type        = string
  default     = ""
}

# RAM Resource Association
variable "policy_ram_resource_associations" {
  description = "A map of RAM resource associations for the created firewall policy"
  type        = map(string)
  default     = null
}
