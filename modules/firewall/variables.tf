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
  nullable    = false
}

variable "description" {
  description = "A friendly description of the firewall"
  type        = string
  default     = null
}

variable "enabled_analysis_types" {
  description = "Set of types for which to collect analysis metrics. Valid values: `TLS_SNI`, `HTTP_HOST`. Defaults to `[]`"
  type        = list(string)
  default     = []
  nullable    = false
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
  default     = false
  nullable    = false
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
