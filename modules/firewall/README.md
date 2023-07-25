# AWS Network Firewall Terraform Module

Terraform module which creates AWS Network Firewall resources.

## Usage

See [`examples`](https://github.com/terraform-aws-modules/terraform-aws-network-firewall/tree/master/examples) directory for working examples to reference:

```hcl
module "network_firewall" {
  source = "terraform-aws-modules/network-firewall/aws//modules/firewall"

  # Firewall
  name        = "exampple"
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
| [aws_networkfirewall_firewall.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall) | resource |
| [aws_networkfirewall_logging_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_logging_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created | `bool` | `true` | no |
| <a name="input_create_logging_configuration"></a> [create\_logging\_configuration](#input\_create\_logging\_configuration) | Controls if a Logging Configuration should be created | `bool` | `false` | no |
| <a name="input_delete_protection"></a> [delete\_protection](#input\_delete\_protection) | A boolean flag indicating whether it is possible to delete the firewall. Defaults to `true` | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | A friendly description of the firewall | `string` | `""` | no |
| <a name="input_encryption_configuration"></a> [encryption\_configuration](#input\_encryption\_configuration) | KMS encryption configuration settings | `any` | `{}` | no |
| <a name="input_firewall_policy_arn"></a> [firewall\_policy\_arn](#input\_firewall\_policy\_arn) | The ARN of the Firewall Policy to use | `string` | `""` | no |
| <a name="input_firewall_policy_change_protection"></a> [firewall\_policy\_change\_protection](#input\_firewall\_policy\_change\_protection) | A boolean flag indicating whether it is possible to change the associated firewall policy. Defaults to `false` | `bool` | `null` | no |
| <a name="input_logging_configuration_destination_config"></a> [logging\_configuration\_destination\_config](#input\_logging\_configuration\_destination\_config) | A list of min 1, max 2 configuration blocks describing the destination for the logging configuration | `any` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | A friendly name of the firewall | `string` | `""` | no |
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
| <a name="output_status"></a> [status](#output\_status) | Nested list of information about the current status of the firewall |
| <a name="output_update_token"></a> [update\_token](#output\_update\_token) | A string token used when updating a firewall |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-network-firewall/blob/master/LICENSE).
