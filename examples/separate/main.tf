provider "aws" {
  region = local.region
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}

locals {
  region     = "us-east-1"
  name       = "network-firewall-ex-${basename(path.cwd)}"
  account_id = data.aws_caller_identity.current.account_id

  vpc_cidr = "10.0.0.0/16"
  num_azs  = 3
  azs      = slice(data.aws_availability_zones.available.names, 0, local.num_azs)

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-network-firewall"
  }
}

################################################################################
# Network Firewall
################################################################################

module "network_firewall" {
  source = "../../modules/firewall"

  name        = local.name
  description = "Example network firewall"

  # Only for example
  delete_protection                 = false
  firewall_policy_change_protection = false
  subnet_change_protection          = false

  firewall_policy_arn = module.network_firewall_policy.arn

  vpc_id = module.vpc.vpc_id
  subnet_mapping = { for i in range(0, local.num_azs) :
    "subnet-${i}" => {
      subnet_id       = element(module.vpc.public_subnets, i)
      ip_address_type = "IPV4"
    }
  }

  # Logging configuration
  create_logging_configuration = true
  logging_configuration_destination_config = [
    {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.logs.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    },
    {
      log_destination = {
        bucketName = aws_s3_bucket.network_firewall_logs.id
        prefix     = local.name
      }
      log_destination_type = "S3"
      log_type             = "FLOW"
    }
  ]

  tags = local.tags
}

module "network_firewall_disabled" {
  source = "../../modules/firewall"

  create = false
}

################################################################################
# Network Firewall Policy
################################################################################

module "network_firewall_policy" {
  source = "../../modules/policy"

  name        = local.name
  description = "Example network firewall policy"

  stateful_rule_group_reference = {
    one = { resource_arn = module.network_firewall_rule_group_stateful.arn }
  }

  stateless_default_actions          = ["aws:pass"]
  stateless_fragment_default_actions = ["aws:drop"]
  stateless_rule_group_reference = {
    one = {
      priority     = 1
      resource_arn = module.network_firewall_rule_group_stateless.arn
    }
  }

  tags = local.tags
}

module "network_firewall_policy_disabled" {
  source = "../../modules/policy"

  create = false
}

################################################################################
# Network Firewall Rule Group
################################################################################

module "network_firewall_rule_group_stateful" {
  source = "../../modules/rule-group"

  name        = "${local.name}-stateful"
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

  # Resource Policy
  create_resource_policy     = true
  attach_resource_policy     = true
  resource_policy_principals = ["arn:aws:iam::${local.account_id}:root"]

  tags = local.tags
}

module "network_firewall_rule_group_stateless" {
  source = "../../modules/rule-group"

  name        = "${local.name}-stateless"
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

  # Resource Policy
  create_resource_policy     = true
  attach_resource_policy     = true
  resource_policy_principals = ["arn:aws:iam::${local.account_id}:root"]

  tags = local.tags
}

module "network_firewall_rule_group_disabled" {
  source = "../../modules/rule-group"

  create = false
}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "${local.name}-logs"
  retention_in_days = 7

  tags = local.tags
}

resource "aws_s3_bucket" "network_firewall_logs" {
  bucket        = "${local.name}-network-firewall-logs-${local.account_id}"
  force_destroy = true

  tags = local.tags
}

# Logging configuration automatically adds this policy if not present
resource "aws_s3_bucket_policy" "network_firewall_logs" {
  bucket = aws_s3_bucket.network_firewall_logs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:PutObject"
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:logs:${local.region}:${local.account_id}:*"
          }
          StringEquals = {
            "aws:SourceAccount" = local.account_id
            "s3:x-amz-acl"      = "bucket-owner-full-control"
          }
        }
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Resource = "${aws_s3_bucket.network_firewall_logs.arn}/${local.name}/AWSLogs/${local.account_id}/*"
        Sid      = "AWSLogDeliveryWrite"
      },
      {
        Action = "s3:GetBucketAcl"
        Condition = {
          ArnLike = {
            "aws:SourceArn" = "arn:aws:logs:${local.region}:${local.account_id}:*"
          }
          StringEquals = {
            "aws:SourceAccount" = local.account_id
          }
        }
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Resource = aws_s3_bucket.network_firewall_logs.arn
        Sid      = "AWSLogDeliveryAclCheck"
      },
    ]
  })
}
