data "aws_region" "current" {}

### AWS VPC ##################################################################################################################################
resource "aws_vpc" "default" {
  for_each             = { for vpc in var.vpcs : vpc.tf_identifier => vpc }
  cidr_block           = each.value.cidr_block
  enable_dns_hostnames = each.value.enable_dns_hostnames
  enable_dns_support   = each.value.enable_dns_support
  instance_tenancy     = each.value.instance_tenancy
  tags                 = merge({ "Name" = each.value.vpc_name }, each.value.tags)
}

locals {
  vpc_id = { for key, vpc in aws_vpc.default : vpc.tags["Name"] => vpc.id }
}

### AWS Internet Gateway #####################################################################################################################
resource "aws_internet_gateway" "default" {
  for_each   = { for igw in var.vpcs : igw.tf_identifier => igw if igw.igw_enable }
  vpc_id     = local.vpc_id[each.value.vpc_name]
  tags       = merge({ "Name" = each.value.internet_gateway_name }, each.value.tags)
  depends_on = [aws_vpc.default]
}

### AWS Subnet ###############################################################################################################################
resource "aws_subnet" "default" {
  for_each          = { for sub in var.subnets : sub.tf_identifier => sub }
  vpc_id            = local.vpc_id[each.value.vpc_name]
  availability_zone = "${data.aws_region.current.name}${each.value.availability_zone}"
  cidr_block        = each.value.cidr_block
  tags              = merge({ "Name" = each.value.subnet_name }, each.value.tags)
}

locals {
  subnet_id = { for key, subnet in aws_subnet.default : subnet.tags["Name"] => subnet.id }
}

### AWS Route Table ##########################################################################################################################
resource "aws_route_table" "default" {
  for_each = { for rtb in var.route_tables : rtb.tf_identifier => rtb }
  vpc_id   = local.vpc_id[each.value.vpc_name]
  tags     = merge({ "Name" = each.value.route_table_name }, each.value.tags)
}
locals {
  route_table_id = { for key, route_table in aws_route_table.default : route_table.tags["Name"] => route_table.id }
}

### AWS Route Table Assocation Subnet ########################################################################################################
resource "aws_route_table_association" "default" {
  for_each       = { for sub in var.subnets : sub.tf_identifier => sub 
  if contains(keys(local.route_table_id), sub.association_route_table_name) && contains(keys(local.subnet_id), sub.subnet_name) }
  route_table_id = local.route_table_id[each.value.association_route_table_name]
  subnet_id      = local.subnet_id[each.value.subnet_name]
}