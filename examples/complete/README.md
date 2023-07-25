# Complete AWS Network Firewall Example

Configuration in this directory creates the following as separate module definitions:

- AWS Network Firewall & Firewall Policy
- AWS Network Firewall Rule Group

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which will incur monetary charges on your AWS bill. Run `terraform destroy` when you no longer need these resources.

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_network_firewall"></a> [network\_firewall](#module\_network\_firewall) | ../.. | n/a |
| <a name="module_network_firewall_disabled"></a> [network\_firewall\_disabled](#module\_network\_firewall\_disabled) | ../.. | n/a |
| <a name="module_network_firewall_rule_group_stateful"></a> [network\_firewall\_rule\_group\_stateful](#module\_network\_firewall\_rule\_group\_stateful) | ../../modules/rule-group | n/a |
| <a name="module_network_firewall_rule_group_stateless"></a> [network\_firewall\_rule\_group\_stateless](#module\_network\_firewall\_rule\_group\_stateless) | ../../modules/rule-group | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_s3_bucket.network_firewall_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.network_firewall_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_arn"></a> [firewall\_arn](#output\_firewall\_arn) | The Amazon Resource Name (ARN) that identifies the firewall |
| <a name="output_firewall_id"></a> [firewall\_id](#output\_firewall\_id) | The Amazon Resource Name (ARN) that identifies the firewall |
| <a name="output_firewall_logging_configuration_id"></a> [firewall\_logging\_configuration\_id](#output\_firewall\_logging\_configuration\_id) | The Amazon Resource Name (ARN) of the associated firewall |
| <a name="output_firewall_policy_arn"></a> [firewall\_policy\_arn](#output\_firewall\_policy\_arn) | The Amazon Resource Name (ARN) that identifies the firewall policy |
| <a name="output_firewall_policy_id"></a> [firewall\_policy\_id](#output\_firewall\_policy\_id) | The Amazon Resource Name (ARN) that identifies the firewall policy |
| <a name="output_firewall_policy_resource_policy_id"></a> [firewall\_policy\_resource\_policy\_id](#output\_firewall\_policy\_resource\_policy\_id) | The Amazon Resource Name (ARN) of the firewall policy associated with the resource policy |
| <a name="output_firewall_policy_update_token"></a> [firewall\_policy\_update\_token](#output\_firewall\_policy\_update\_token) | A string token used when updating a firewall policy |
| <a name="output_firewall_rule_group_stateful_arn"></a> [firewall\_rule\_group\_stateful\_arn](#output\_firewall\_rule\_group\_stateful\_arn) | The Amazon Resource Name (ARN) that identifies the rule group |
| <a name="output_firewall_rule_group_stateful_id"></a> [firewall\_rule\_group\_stateful\_id](#output\_firewall\_rule\_group\_stateful\_id) | The Amazon Resource Name (ARN) that identifies the rule group |
| <a name="output_firewall_rule_group_stateful_resource_policy_id"></a> [firewall\_rule\_group\_stateful\_resource\_policy\_id](#output\_firewall\_rule\_group\_stateful\_resource\_policy\_id) | The Amazon Resource Name (ARN) of the rule group associated with the resource policy |
| <a name="output_firewall_rule_group_stateful_update_token"></a> [firewall\_rule\_group\_stateful\_update\_token](#output\_firewall\_rule\_group\_stateful\_update\_token) | A string token used when updating the rule group |
| <a name="output_firewall_rule_group_stateless_arn"></a> [firewall\_rule\_group\_stateless\_arn](#output\_firewall\_rule\_group\_stateless\_arn) | The Amazon Resource Name (ARN) that identifies the rule group |
| <a name="output_firewall_rule_group_stateless_id"></a> [firewall\_rule\_group\_stateless\_id](#output\_firewall\_rule\_group\_stateless\_id) | The Amazon Resource Name (ARN) that identifies the rule group |
| <a name="output_firewall_rule_group_stateless_resource_policy_id"></a> [firewall\_rule\_group\_stateless\_resource\_policy\_id](#output\_firewall\_rule\_group\_stateless\_resource\_policy\_id) | The Amazon Resource Name (ARN) of the rule group associated with the resource policy |
| <a name="output_firewall_rule_group_stateless_update_token"></a> [firewall\_rule\_group\_stateless\_update\_token](#output\_firewall\_rule\_group\_stateless\_update\_token) | A string token used when updating the rule group |
| <a name="output_firewall_status"></a> [firewall\_status](#output\_firewall\_status) | Nested list of information about the current status of the firewall |
| <a name="output_firewall_update_token"></a> [firewall\_update\_token](#output\_firewall\_update\_token) | A string token used when updating a firewall |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

Apache-2.0 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-network-firewall/blob/master/LICENSE).
