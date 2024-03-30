locals {
  create_route = length(var.routes) > 0 ? true : false
}

data "aws_route_table" "default" {
  for_each = { for route_rule in var.routes : route_rule.route_table_name => route_rule
  if local.create_route }
  tags = {
    Name = each.value.route_table_name
  }
}

data "aws_internet_gateway" "default" {
  for_each = { for route_rule in var.routes : route_rule.target_name => route_rule
  if local.create_route && route_rule.target_type == "internet_gateway" }
  tags = {
    Name = each.value.target_name
  }
}

data "aws_nat_gateway" "default" {
  for_each = { for route_rule in var.routes : route_rule.target_name => route_rule
  if local.create_route && route_rule.target_type == "nat_gateway" }
  tags = {
    Name = each.value.target_name
  }
}