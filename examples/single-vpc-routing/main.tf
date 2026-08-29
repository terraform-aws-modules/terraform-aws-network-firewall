provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  # Workloads live in the intra subnets. They are used here because the VPC module gives
  # them no default route of their own, so the firewall routes below are the only egress
  # path and nothing conflicts
  protected_cidrs = { for i, az in local.azs : az => cidrsubnet(local.vpc_cidr, 8, i + 10) }

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
  source = "../.."

  name        = local.name
  description = "Single VPC inspection with module managed routing"

  # Only for example
  delete_protection                 = false
  firewall_policy_change_protection = false
  subnet_change_protection          = false

  vpc_id = module.vpc.vpc_id

  # The firewall sits in the public subnets, which already route to the internet gateway.
  # Nothing else is placed there: a firewall cannot inspect traffic whose source or
  # destination is inside a firewall subnet
  subnet_mapping = { for i, az in local.azs :
    az => {
      subnet_id       = element(module.vpc.public_subnets, i)
      ip_address_type = "IPV4"
    }
  }

  # Everything below replaces reading the endpoint for each availability zone out of
  # `status` and writing six routes by hand
  routing_configuration = {
    single_vpc = {
      # Inbound traffic reaches the firewall before the workloads. Without this the
      # firewall sees only one direction of each flow
      igw_route_table = aws_route_table.igw_ingress.id

      # Outbound traffic from each protected subnet reaches the firewall in its own zone
      protected_subnet_route_tables = { for i, az in local.azs :
        az => element(module.vpc.intra_route_table_ids, i)
      }

      protected_subnet_cidr_blocks = local.protected_cidrs
    }
  }

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = local.name
  cidr = local.vpc_cidr

  azs            = local.azs
  public_subnets = [for i, az in local.azs : cidrsubnet(local.vpc_cidr, 8, i)]
  intra_subnets  = [for az in local.azs : local.protected_cidrs[az]]

  # One route table per intra subnet, so each can point at the firewall endpoint in its
  # own availability zone
  create_multiple_intra_route_tables = true

  tags = local.tags
}

# A gateway route table must be dedicated to the gateway and associated with no subnet,
# so it is created here rather than by the VPC module
resource "aws_route_table" "igw_ingress" {
  vpc_id = module.vpc.vpc_id

  tags = merge(local.tags, { Name = "${local.name}-igw-ingress" })
}

resource "aws_route_table_association" "igw_ingress" {
  gateway_id     = module.vpc.igw_id
  route_table_id = aws_route_table.igw_ingress.id
}
