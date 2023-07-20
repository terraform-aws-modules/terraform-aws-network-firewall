# AWS Network Firewall Terraform Module

Terraform module which creates AWS Network Firewall resources.

## Usage

See [`examples`](https://github.com/clowdhaus/terraform-aws-vpc-v5/tree/main/examples) directory for working examples to reference:

```hcl
module "network_firewall" {
  source = "terraform-aws-modules/vpc/aws//modules/network-firewall"

  name        = "Example"
  description = "Example network firewall"

  vpc_id         = "vpc-12345678"
  subnet_mapping = ["subnet-12345678", "subnet-87654321"]

  # Policy
  policy_description = "Example network firewall policy"
  policy_stateful_rule_group_reference = [
    { rule_group_key = "stateful_ex1" },
    { rule_group_key = "stateful_ex2" },
    { rule_group_key = "stateful_ex3" },
    { rule_group_key = "stateful_ex4" },
  ]

  policy_stateless_default_actions          = ["aws:pass"]
  policy_stateless_fragment_default_actions = ["aws:drop"]
  policy_stateless_rule_group_reference = [
    {
      priority       = 1
      rule_group_key = "stateless_ex1"
    },
  ]

  # Rule Group(s)
  rule_groups = {

    stateful_ex1 = {
      name        = "Example-stateful-ex1"
      description = "Stateful Inspection for denying access to a domain"
      type        = "STATEFUL"
      capacity    = 100

      rule_group = {
        rules_source = {
          rules_source_list = {
            generated_rules_type = "DENYLIST"
            target_types         = ["HTTP_HOST"]
            targets              = ["test.example.com"]
          }
        }
      }

      # Resource Policy - Rule Group
      create_resource_policy     = true
      attach_resource_policy     = true
      resource_policy_principals = ["arn:aws:iam::123456789012:root"]
    }

    stateful_ex2 = {
      name        = "Example-stateful-ex2"
      description = "Stateful Inspection for permitting packets from a source IP address"
      type        = "STATEFUL"
      capacity    = 50

      rule_group = {
        rules_source = {
          stateful_rule = [{
            action = "PASS"
            header = {
              destination      = "ANY"
              destination_port = "ANY"
              protocol         = "HTTP"
              direction        = "ANY"
              source_port      = "ANY"
              source           = "1.2.3.4"
            }
            rule_option = [{
              keyword = "sid:1"
            }]
          }]
        }
      }
    }

    stateful_ex3 = {
      name        = "Example-stateful-ex3"
      description = "Stateful Inspection for blocking packets from going to an intended destination"
      type        = "STATEFUL"
      capacity    = 100

      rule_group = {
        rules_source = {
          stateful_rule = [{
            action = "DROP"
            header = {
              destination      = "124.1.1.24/32"
              destination_port = 53
              direction        = "ANY"
              protocol         = "TCP"
              source           = "1.2.3.4/32"
              source_port      = 53
            }
            rule_option = [{
              keyword = "sid:1"
            }]
          }]
        }
      }
    }

    stateful_ex4 = {
      name        = "Example-stateful-ex4"
      description = "Stateful Inspection from rule group specifications using rule variables and Suricata format rules"
      type        = "STATEFUL"
      capacity    = 100

      rule_group = {
        rule_variables = {
          ip_sets = [{
            key = "WEBSERVERS_HOSTS"
            ip_set = {
              definition = ["10.0.0.0/16", "10.0.1.0/24", "192.168.0.0/16"]
            }
            }, {
            key = "EXTERNAL_HOST"
            ip_set = {
              definition = ["1.2.3.4/32"]
            }
          }]
          port_sets = [{
            key = "HTTP_PORTS"
            port_set = {
              definition = ["443", "80"]
            }
          }]
        }
        rules_source = {
          rules_string = <<-EOT
          alert icmp any any -> any any (msg: "Allowing ICMP packets"; sid:1; rev:1;)
          pass icmp any any -> any any (msg: "Allowing ICMP packets"; sid:2; rev:1;)
          EOT
        }
      }
    }

    stateless_ex1 = {
      name        = "Example-stateless-ex1"
      description = "Stateless Inspection with a Custom Action"
      type        = "STATELESS"
      capacity    = 100

      rule_group = {
        rules_source = {
          stateless_rules_and_custom_actions = {
            custom_action = [{
              action_definition = {
                publish_metric_action = {
                  dimension = [{
                    value = "2"
                  }]
                }
              }
              action_name = "ExampleMetricsAction"
            }]
            stateless_rule = [{
              priority = 1
              rule_definition = {
                actions = ["aws:pass", "ExampleMetricsAction"]
                match_attributes = {
                  source = [{
                    address_definition = "1.2.3.4/32"
                  }]
                  source_port = [{
                    from_port = 443
                    to_port   = 443
                  }]
                  destination = [{
                    address_definition = "124.1.1.5/32"
                  }]
                  destination_port = [{
                    from_port = 443
                    to_port   = 443
                  }]
                  protocols = [6]
                  tcp_flag = [{
                    flags = ["SYN"]
                    masks = ["SYN", "ACK"]
                  }]
                }
              }
            }]
          }
        }
      }

      # Resource Policy - Rule Group
      create_resource_policy     = true
      attach_resource_policy     = true
      resource_policy_principals = ["arn:aws:iam::123456789012:root"]
    }
  }

  # Resource Policy - Firewall Policy
  create_firewall_policy_resource_policy     = true
  attach_firewall_policy_resource_policy     = true
  firewall_policy_resource_policy_principals = ["arn:aws:iam::123456789012:root"]

  # Logging configuration
  create_logging_configuration = true
  logging_configuration_destination_config = [
    {
      log_destination = {
        logGroup = "/aws/networkfirewall/Example"
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    },
    {
      log_destination = {
        bucketName = "network-firewall-example-logs"
        prefix     = local.name
      }
      log_destination_type = "S3"
      log_type             = "FLOW"
    }
  ]

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_networkfirewall_resource_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_resource_policy) | resource |
| [aws_networkfirewall_rule_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group) | resource |
| [aws_ram_resource_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_iam_policy_document.rule_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach_resource_policy"></a> [attach\_resource\_policy](#input\_attach\_resource\_policy) | Controls if a resource policy should be attached to the rule group | `bool` | `false` | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | The maximum number of operating resources that this rule group can use. For a stateless rule group, the capacity required is the sum of the capacity requirements of the individual rules. For a stateful rule group, the minimum capacity required is the number of individual rules | `number` | `100` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if Network Firewall resources should be created | `bool` | `true` | no |
| <a name="input_create_resource_policy"></a> [create\_resource\_policy](#input\_create\_resource\_policy) | Controls if a resource policy should be created | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | A friendly description of the rule group | `string` | `null` | no |
| <a name="input_encryption_configuration"></a> [encryption\_configuration](#input\_encryption\_configuration) | KMS encryption configuration settings | `any` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | A friendly name of the rule group | `string` | `""` | no |
| <a name="input_ram_resource_associations"></a> [ram\_resource\_associations](#input\_ram\_resource\_associations) | A map of RAM resource associations for the created rule group | `map(string)` | `{}` | no |
| <a name="input_resource_policy"></a> [resource\_policy](#input\_resource\_policy) | The policy JSON to use for the resource policy; required when `create_resource_policy` is `false` | `string` | `""` | no |
| <a name="input_resource_policy_actions"></a> [resource\_policy\_actions](#input\_resource\_policy\_actions) | A list of IAM actions allowed in the resource policy | `list(string)` | `[]` | no |
| <a name="input_resource_policy_principals"></a> [resource\_policy\_principals](#input\_resource\_policy\_principals) | A list of IAM principals allowed in the resource policy | `list(string)` | `[]` | no |
| <a name="input_rule_group"></a> [rule\_group](#input\_rule\_group) | A configuration block that defines the rule group rules. Required unless `rules` is specified | `any` | `{}` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | The stateful rule group rules specifications in Suricata file format, with one rule per line. Use this to import your existing Suricata compatible rule groups. Required unless `rule_group` is specified | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | Whether the rule group is stateless (containing stateless rules) or stateful (containing stateful rules). Valid values include: `STATEFUL` or `STATELESS` | `string` | `"STATELESS"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) that identifies the rule group |
| <a name="output_id"></a> [id](#output\_id) | The Amazon Resource Name (ARN) that identifies the rule group |
| <a name="output_resource_policy_id"></a> [resource\_policy\_id](#output\_resource\_policy\_id) | The Amazon Resource Name (ARN) of the rule group associated with the resource policy |
| <a name="output_update_token"></a> [update\_token](#output\_update\_token) | A string token used when updating the rule group |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/clowdhaus/terraform-aws-vpc-v5/blob/main/LICENSE).
