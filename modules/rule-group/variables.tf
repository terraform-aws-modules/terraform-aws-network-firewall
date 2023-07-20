variable "create" {
  description = "Controls if Network Firewall resources should be created"
  type        = bool
  default     = true
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
  type        = any
  default     = {}
}

variable "name" {
  description = "A friendly name of the rule group"
  type        = string
  default     = ""
}

variable "rule_group" {
  description = "A configuration block that defines the rule group rules. Required unless `rules` is specified"
  type        = any
  default     = {}
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
