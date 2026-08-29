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

variable "enable_monitoring_dashboard" {
  description = "Whether to enable monitoring dashboard for the logging configuration"
  type        = bool
  default     = null
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

variable "policy_tls_inspection_configuration_arn" {
  description = "The ARN of the TLS inspection configuration to associate with the firewall policy"
  type        = string
  default     = null
}

variable "policy_enable_tls_session_holding" {
  description = "Whether to allow the firewall to hold TLS sessions to allow TLS traffic processing before downstream connection establishment. When set to `true`, adds latency — enable only if TLS.SNI rule groups are active in the policy"
  type        = bool
  default     = null
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

################################################################################
# Routing
################################################################################

variable "routing_configuration" {
  description = "Routing to create so that traffic actually reaches the firewall. Exactly one architecture may be configured. The firewall endpoint serving each availability zone is resolved by the module, so callers do not need to read it out of `status`"
  type = object({
    # Inspection of traffic entering and leaving a single VPC through an internet gateway
    single_vpc = optional(object({
      # Route table associated with the internet gateway, which must be dedicated to the
      # gateway and associated with no subnet. Omit to route outbound traffic only
      igw_route_table = optional(string)
      # Availability zone to the route table of the protected subnet in that zone
      protected_subnet_route_tables = optional(map(string), {})
      # Availability zone to the CIDR block of the protected subnet in that zone, used
      # for the return routes on the internet gateway's route table
      protected_subnet_cidr_blocks = optional(map(string), {})
      # Destination for the outbound route
      destination_cidr_block = optional(string, "0.0.0.0/0")
    }))
    # Inspection of traffic between subnets in the same VPC, using routes more specific
    # than the local route
    intra_vpc_inspection = optional(object({
      routes = optional(map(object({
        route_table_id              = string
        destination_ipv4_cidr_block = optional(string)
        destination_ipv6_cidr_block = optional(string)
        # Which zone's endpoint to send this traffic to, normally the zone the source
        # subnet is in so that traffic stays in zone
        availability_zone = string
      })), {})
    }))
  })
  default = null

  validation {
    condition     = var.routing_configuration == null ? true : length([for k, v in var.routing_configuration : k if v != null]) <= 1
    error_message = "Only one architecture may be configured in `routing_configuration`."
  }

  validation {
    condition = try(var.routing_configuration.single_vpc, null) == null ? true : (
      try(var.routing_configuration.single_vpc.igw_route_table, null) == null ||
      length(var.routing_configuration.single_vpc.protected_subnet_cidr_blocks) > 0
    )
    error_message = "`protected_subnet_cidr_blocks` is required when `igw_route_table` is set, because the internet gateway needs a route per protected subnet."
  }
}
