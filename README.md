# AWS Network Firewall Terraform module

Terraform module which creates AWS network firewall resources.

[![SWUbanner](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner2-direct.svg)](https://github.com/vshymanskyy/StandWithUkraine/blob/main/docs/README.md)

## Usage

This project supports creating resources through individual sub-modules for better support for RAM resource sharing, or through a single module that creates both the firewall and firewall policy resources.
See the respective sub-module directory for more details and example usage.

```hcl
module "network_firewall" {
  source = "terraform-aws-modules/network-firewall/aws"

  # Firewall
  name        = "example"
  description = "Example network firewall"

  vpc_id = "vpc-1234556abcdef"
  subnet_mapping = {
    subnet1 = {
      subnet_id       = "subnet-abcde012"
      ip_address_type = "IPV4"
    }
    subnet2 = {
      subnet_id       = "subnet-bcde012a"
      ip_address_type = "IPV4"
    }
    subnet2 = {
      subnet_id       = "subnet-fghi345a"
      ip_address_type = "IPV4"
    }
  }

  # Logging configuration
  create_logging_configuration = true
  logging_configuration_destination_config = [
    {
      log_destination = {
        logGroup = "/aws/network-firewall/example"
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    },
    {
      log_destination = {
        bucketName = "s3-example-bucket-firewall-flow-logs"
        prefix     = "example"
      }
      log_destination_type = "S3"
      log_type             = "FLOW"
    }
  ]

  # Policy
  policy_name        = "example"
  policy_description = "Example network firewall policy"

  policy_stateful_rule_group_reference = {
    one = {
      priority     = 0
      resource_arn = "arn:aws:network-firewall:us-east-1:1234567890:stateful-rulegroup/example"
    }
  }

  policy_stateless_default_actions          = ["aws:pass"]
  policy_stateless_fragment_default_actions = ["aws:drop"]
  policy_stateless_rule_group_reference = {
    one = {
      priority     = 0
      resource_arn = "arn:aws:network-firewall:us-east-1:1234567890:stateless-rulegroup/example"
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```


## Examples

Examples codified under the [`examples`](https://github.com/terraform-aws-modules/terraform-aws-network-firewall/tree/master/examples) are intended to give users references for how to use the module(s) as well as testing/validating changes to the source code of the module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow maintainers to test your changes and to keep the examples up to date for users. Thank you!

- [Complete](https://github.com/terraform-aws-modules/terraform-aws-network-firewall/tree/master/examples/complete)
- [Separate](https://github.com/terraform-aws-modules/terraform-aws-network-firewall/tree/master/examples/separate)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_firewall"></a> [firewall](#module\_firewall) | ./modules/firewall | n/a |
| <a name="module_policy"></a> [policy](#module\_policy) | ./modules/policy | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created | `bool` | `true` | no |
| <a name="input_create_logging_configuration"></a> [create\_logging\_configuration](#input\_create\_logging\_configuration) | Controls if a Logging Configuration should be created | `bool` | `false` | no |
| <a name="input_create_policy"></a> [create\_policy](#input\_create\_policy) | Controls if policy should be created | `bool` | `true` | no |
| <a name="input_create_policy_resource_policy"></a> [create\_policy\_resource\_policy](#input\_create\_policy\_resource\_policy) | Controls if a resource policy should be created | `bool` | `false` | no |
| <a name="input_delete_protection"></a> [delete\_protection](#input\_delete\_protection) | A boolean flag indicating whether it is possible to delete the firewall. Defaults to `true` | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | A friendly description of the firewall | `string` | `""` | no |
| <a name="input_encryption_configuration"></a> [encryption\_configuration](#input\_encryption\_configuration) | KMS encryption configuration settings | `any` | `{}` | no |
| <a name="input_firewall_policy_arn"></a> [firewall\_policy\_arn](#input\_firewall\_policy\_arn) | The ARN of the Firewall Policy to use | `string` | `""` | no |
| <a name="input_firewall_policy_change_protection"></a> [firewall\_policy\_change\_protection](#input\_firewall\_policy\_change\_protection) | A boolean flag indicating whether it is possible to change the associated firewall policy. Defaults to `false` | `bool` | `null` | no |
| <a name="input_logging_configuration_destination_config"></a> [logging\_configuration\_destination\_config](#input\_logging\_configuration\_destination\_config) | A list of min 1, max 2 configuration blocks describing the destination for the logging configuration | `any` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | A friendly name of the firewall | `string` | `""` | no |
| <a name="input_policy_attach_resource_policy"></a> [policy\_attach\_resource\_policy](#input\_policy\_attach\_resource\_policy) | Controls if a resource policy should be attached to the firewall policy | `bool` | `false` | no |
| <a name="input_policy_description"></a> [policy\_description](#input\_policy\_description) | A friendly description of the firewall policy | `string` | `null` | no |
| <a name="input_policy_encryption_configuration"></a> [policy\_encryption\_configuration](#input\_policy\_encryption\_configuration) | KMS encryption configuration settings | `any` | `{}` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | A friendly name of the firewall policy | `string` | `""` | no |
| <a name="input_policy_ram_resource_associations"></a> [policy\_ram\_resource\_associations](#input\_policy\_ram\_resource\_associations) | A map of RAM resource associations for the created firewall policy | `map(string)` | `{}` | no |
| <a name="input_policy_resource_policy"></a> [policy\_resource\_policy](#input\_policy\_resource\_policy) | The policy JSON to use for the resource policy; required when `create_resource_policy` is `false` | `string` | `""` | no |
| <a name="input_policy_resource_policy_actions"></a> [policy\_resource\_policy\_actions](#input\_policy\_resource\_policy\_actions) | A list of IAM actions allowed in the resource policy | `list(string)` | `[]` | no |
| <a name="input_policy_resource_policy_principals"></a> [policy\_resource\_policy\_principals](#input\_policy\_resource\_policy\_principals) | A list of IAM principals allowed in the resource policy | `list(string)` | `[]` | no |
| <a name="input_policy_stateful_default_actions"></a> [policy\_stateful\_default\_actions](#input\_policy\_stateful\_default\_actions) | Set of actions to take on a packet if it does not match any stateful rules in the policy. This can only be specified if the policy has a `stateful_engine_options` block with a rule\_order value of `STRICT_ORDER`. You can specify one of either or neither values of `aws:drop_strict` or `aws:drop_established`, as well as any combination of `aws:alert_strict` and `aws:alert_established` | `list(string)` | `[]` | no |
| <a name="input_policy_stateful_engine_options"></a> [policy\_stateful\_engine\_options](#input\_policy\_stateful\_engine\_options) | A configuration block that defines options on how the policy handles stateful rules. See [Stateful Engine Options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy#stateful-engine-options) for details | `any` | `{}` | no |
| <a name="input_policy_stateful_rule_group_reference"></a> [policy\_stateful\_rule\_group\_reference](#input\_policy\_stateful\_rule\_group\_reference) | Set of configuration blocks containing references to the stateful rule groups that are used in the policy. See [Stateful Rule Group Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy#stateful-rule-group-reference) for details | `any` | `{}` | no |
| <a name="input_policy_stateless_custom_action"></a> [policy\_stateless\_custom\_action](#input\_policy\_stateless\_custom\_action) | Set of configuration blocks describing the custom action definitions that are available for use in the firewall policy's `stateless_default_actions` | `any` | `{}` | no |
| <a name="input_policy_stateless_default_actions"></a> [policy\_stateless\_default\_actions](#input\_policy\_stateless\_default\_actions) | Set of actions to take on a packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: `aws:drop`, `aws:pass`, or `aws:forward_to_sfe` | `list(string)` | <pre>[<br>  "aws:pass"<br>]</pre> | no |
| <a name="input_policy_stateless_fragment_default_actions"></a> [policy\_stateless\_fragment\_default\_actions](#input\_policy\_stateless\_fragment\_default\_actions) | Set of actions to take on a fragmented packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: `aws:drop`, `aws:pass`, or `aws:forward_to_sfe` | `list(string)` | <pre>[<br>  "aws:pass"<br>]</pre> | no |
| <a name="input_policy_stateless_rule_group_reference"></a> [policy\_stateless\_rule\_group\_reference](#input\_policy\_stateless\_rule\_group\_reference) | Set of configuration blocks containing references to the stateless rule groups that are used in the policy. See [Stateless Rule Group Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy#stateless-rule-group-reference) for details | `any` | `{}` | no |
| <a name="input_policy_tags"></a> [policy\_tags](#input\_policy\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_subnet_change_protection"></a> [subnet\_change\_protection](#input\_subnet\_change\_protection) | A boolean flag indicating whether it is possible to change the associated subnet(s). Defaults to `true` | `bool` | `true` | no |
| <a name="input_subnet_mapping"></a> [subnet\_mapping](#input\_subnet\_mapping) | Set of configuration blocks describing the public subnets. Each subnet must belong to a different Availability Zone in the VPC. AWS Network Firewall creates a firewall endpoint in each subnet | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The unique identifier of the VPC where AWS Network Firewall should create the firewall | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) that identifies the firewall |
| <a name="output_id"></a> [id](#output\_id) | The Amazon Resource Name (ARN) that identifies the firewall |
| <a name="output_logging_configuration_id"></a> [logging\_configuration\_id](#output\_logging\_configuration\_id) | The Amazon Resource Name (ARN) of the associated firewall |
| <a name="output_policy_arn"></a> [policy\_arn](#output\_policy\_arn) | The Amazon Resource Name (ARN) that identifies the firewall policy |
| <a name="output_policy_id"></a> [policy\_id](#output\_policy\_id) | The Amazon Resource Name (ARN) that identifies the firewall policy |
| <a name="output_policy_resource_policy_id"></a> [policy\_resource\_policy\_id](#output\_policy\_resource\_policy\_id) | The Amazon Resource Name (ARN) of the firewall policy associated with the resource policy |
| <a name="output_policy_update_token"></a> [policy\_update\_token](#output\_policy\_update\_token) | A string token used when updating a firewall policy |
| <a name="output_status"></a> [status](#output\_status) | Nested list of information about the current status of the firewall |
| <a name="output_update_token"></a> [update\_token](#output\_update\_token) | A string token used when updating a firewall |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-network-firewall/blob/master/LICENSE).
