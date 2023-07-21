
# module "network_firewall" {
#   source = "terraform-aws-modules/network-firewall/aws"

#   # Firewall
#   name        = "exampple"
#   description = "Example network firewall"

#   # Only for example
#   delete_protection                 = false
#   firewall_policy_change_protection = false
#   subnet_change_protection          = false

#   vpc_id = "vpc-1234556abcdef"
#   subnet_mapping = {
#     subnet1 = {
#       subnet_id       = "subnet-abcde012"
#       ip_address_type = "IPV4"
#     }
#     subnet2 = {
#       subnet_id       = "subnet-bcde012a"
#       ip_address_type = "IPV4"
#     }
#     subnet2 = {
#       subnet_id       = "subnet-fghi345a"
#       ip_address_type = "IPV4"
#     }
#   }

#   # Logging configuration
#   create_logging_configuration = true
#   logging_configuration_destination_config = [
#     {
#       log_destination = {
#         logGroup = "/aws/network-firewall/example"
#       }
#       log_destination_type = "CloudWatchLogs"
#       log_type             = "ALERT"
#     },
#     {
#       log_destination = {
#         bucketName = "s3-example-bucket-firewall-flow-logs"
#         prefix     = "example"
#       }
#       log_destination_type = "S3"
#       log_type             = "FLOW"
#     }
#   ]

#   # Policy
#   policy_name        = "example"
#   policy_description = "Example network firewall policy"

#   policy_stateful_rule_group_reference = {
#     one = { resource_arn = module.network_firewall_rule_group_stateful.arn }
#   }

#   policy_stateless_default_actions          = ["aws:pass"]
#   policy_stateless_fragment_default_actions = ["aws:drop"]
#   policy_stateless_rule_group_reference = {
#     one = {
#       priority     = 1
#       resource_arn = module.network_firewall_rule_group_stateless.arn
#     }
#   }

#   tags = local.tags
# }

# module "network_firewall_disabled" {
#   source = "../.."

#   create = false
# }

# ################################################################################
# # Network Firewall Rule Group
# ################################################################################

# module "network_firewall_rule_group_stateful" {
#   source = "../../modules/rule-group"

#   name        = "${local.name}-stateful"
#   description = "Stateful Inspection for denying access to a domain"
#   type        = "STATEFUL"
#   capacity    = 100

#   rule_group = {
#     rules_source = {
#       rules_source_list = {
#         generated_rules_type = "DENYLIST"
#         target_types         = ["HTTP_HOST"]
#         targets              = ["test.example.com"]
#       }
#     }
#   }

#   # Resource Policy
#   create_resource_policy     = true
#   attach_resource_policy     = true
#   resource_policy_principals = ["arn:aws:iam::${local.account_id}:root"]

#   tags = local.tags
# }

# module "network_firewall_rule_group_stateless" {
#   source = "../../modules/rule-group"

#   name        = "${local.name}-stateless"
#   description = "Stateless Inspection with a Custom Action"
#   type        = "STATELESS"
#   capacity    = 100

#   rule_group = {
#     rules_source = {
#       stateless_rules_and_custom_actions = {
#         custom_action = [{
#           action_definition = {
#             publish_metric_action = {
#               dimension = [{
#                 value = "2"
#               }]
#             }
#           }
#           action_name = "ExampleMetricsAction"
#         }]
#         stateless_rule = [{
#           priority = 1
#           rule_definition = {
#             actions = ["aws:pass", "ExampleMetricsAction"]
#             match_attributes = {
#               source = [{
#                 address_definition = "1.2.3.4/32"
#               }]
#               source_port = [{
#                 from_port = 443
#                 to_port   = 443
#               }]
#               destination = [{
#                 address_definition = "124.1.1.5/32"
#               }]
#               destination_port = [{
#                 from_port = 443
#                 to_port   = 443
#               }]
#               protocols = [6]
#               tcp_flag = [{
#                 flags = ["SYN"]
#                 masks = ["SYN", "ACK"]
#               }]
#             }
#           }
#         }]
#       }
#     }
#   }

#   # Resource Policy
#   create_resource_policy     = true
#   attach_resource_policy     = true
#   resource_policy_principals = ["arn:aws:iam::${local.account_id}:root"]

#   tags = local.tags
# }
