# AWS Network Firewall Policy Terraform Module

Terraform module which creates AWS Network Firewall policy resources.

## Usage

See [`examples`](https://github.com/terraform-aws-modules/terraform-aws-network-firewall/tree/master/examples) directory for working examples to reference:

```hcl
module "network_firewall_policy" {
  source = "terraform-aws-modules/network-firewall/aws//modules/policy"

  name        = "example"
  description = "Example network firewall policy"

  stateful_rule_group_reference = {
    one = {
      priority     = 0
      resource_arn = "arn:aws:network-firewall:us-east-1:1234567890:stateful-rulegroup/example"
    }
  }

  stateless_default_actions          = ["aws:pass"]
  stateless_fragment_default_actions = ["aws:drop"]
  stateless_rule_group_reference = {
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
| [aws_networkfirewall_firewall_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy) | resource |
| [aws_networkfirewall_resource_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_resource_policy) | resource |
| [aws_ram_resource_association.firewall_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ram_resource_association) | resource |
| [aws_iam_policy_document.firewall_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attach_resource_policy"></a> [attach\_resource\_policy](#input\_attach\_resource\_policy) | Controls if a resource policy should be attached to the firewall policy | `bool` | `false` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created | `bool` | `true` | no |
| <a name="input_create_resource_policy"></a> [create\_resource\_policy](#input\_create\_resource\_policy) | Controls if a resource policy should be created | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | A friendly description of the firewall policy | `string` | `null` | no |
| <a name="input_encryption_configuration"></a> [encryption\_configuration](#input\_encryption\_configuration) | KMS encryption configuration settings | `any` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | A friendly name of the firewall policy | `string` | `""` | no |
| <a name="input_ram_resource_associations"></a> [ram\_resource\_associations](#input\_ram\_resource\_associations) | A map of RAM resource associations for the created firewall policy | `map(string)` | `{}` | no |
| <a name="input_resource_policy"></a> [resource\_policy](#input\_resource\_policy) | The policy JSON to use for the resource policy; required when `create_resource_policy` is `false` | `string` | `""` | no |
| <a name="input_resource_policy_actions"></a> [resource\_policy\_actions](#input\_resource\_policy\_actions) | A list of IAM actions allowed in the resource policy | `list(string)` | `[]` | no |
| <a name="input_resource_policy_principals"></a> [resource\_policy\_principals](#input\_resource\_policy\_principals) | A list of IAM principals allowed in the resource policy | `list(string)` | `[]` | no |
| <a name="input_stateful_default_actions"></a> [stateful\_default\_actions](#input\_stateful\_default\_actions) | Set of actions to take on a packet if it does not match any stateful rules in the policy. This can only be specified if the policy has a `stateful_engine_options` block with a rule\_order value of `STRICT_ORDER`. You can specify one of either or neither values of `aws:drop_strict` or `aws:drop_established`, as well as any combination of `aws:alert_strict` and `aws:alert_established` | `list(string)` | `[]` | no |
| <a name="input_stateful_engine_options"></a> [stateful\_engine\_options](#input\_stateful\_engine\_options) | A configuration block that defines options on how the policy handles stateful rules. See [Stateful Engine Options](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy#stateful-engine-options) for details | `any` | `{}` | no |
| <a name="input_stateful_rule_group_reference"></a> [stateful\_rule\_group\_reference](#input\_stateful\_rule\_group\_reference) | Set of configuration blocks containing references to the stateful rule groups that are used in the policy. See [Stateful Rule Group Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy#stateful-rule-group-reference) for details | `any` | `{}` | no |
| <a name="input_stateless_custom_action"></a> [stateless\_custom\_action](#input\_stateless\_custom\_action) | Set of configuration blocks describing the custom action definitions that are available for use in the firewall policy's `stateless_default_actions` | `any` | `{}` | no |
| <a name="input_stateless_default_actions"></a> [stateless\_default\_actions](#input\_stateless\_default\_actions) | Set of actions to take on a packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: `aws:drop`, `aws:pass`, or `aws:forward_to_sfe` | `list(string)` | <pre>[<br>  "aws:pass"<br>]</pre> | no |
| <a name="input_stateless_fragment_default_actions"></a> [stateless\_fragment\_default\_actions](#input\_stateless\_fragment\_default\_actions) | Set of actions to take on a fragmented packet if it does not match any of the stateless rules in the policy. You must specify one of the standard actions including: `aws:drop`, `aws:pass`, or `aws:forward_to_sfe` | `list(string)` | <pre>[<br>  "aws:pass"<br>]</pre> | no |
| <a name="input_stateless_rule_group_reference"></a> [stateless\_rule\_group\_reference](#input\_stateless\_rule\_group\_reference) | Set of configuration blocks containing references to the stateless rule groups that are used in the policy. See [Stateless Rule Group Reference](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy#stateless-rule-group-reference) for details | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) that identifies the firewall policy |
| <a name="output_id"></a> [id](#output\_id) | The Amazon Resource Name (ARN) that identifies the firewall policy |
| <a name="output_resource_policy_id"></a> [resource\_policy\_id](#output\_resource\_policy\_id) | The Amazon Resource Name (ARN) of the firewall policy associated with the resource policy |
| <a name="output_update_token"></a> [update\_token](#output\_update\_token) | A string token used when updating a firewall policy |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-network-firewall/blob/master/LICENSE).
