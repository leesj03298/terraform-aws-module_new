locals {
  create_route = length(var.routes) > 0 ? true : false
  route_table_name_optimize = distinct([for route in var.routes : route.route_table_name])
  internet_gateway_optimize = distinct([for route in var.routes : route.target_name if route.target_type == "internet_gateway"])
  nat_gateway_optimize = distinct([for route in var.routes : route.target_name if route.target_type == "nat_gateway"])
}

data "aws_route_table" "default" {
  for_each = toset(local.route_table_name_optimize)
  tags = {
    Name = each.key
  }
}

data "aws_internet_gateway" "default" {
  for_each = toset(local.internet_gateway_optimize)
  tags = {
    Name = each.key
  }
}

data "aws_nat_gateway" "default" {
  for_each = toset(local.nat_gateway_optimize)
  tags = {
    Name = each.key
  }
}