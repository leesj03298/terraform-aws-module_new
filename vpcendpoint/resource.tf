resource "aws_vpc_endpoint" "VPC_Endpoint_Gateway" {
  for_each          = { for vpce in var.vpcendpoint_gateway : "${data.aws_vpc.default[vpce.vpc_name].id}_${vpce.service_name}" => vpce }
  vpc_endpoint_type = "Gateway"
  service_name      = each.value.service_name
  vpc_id            = data.aws_vpc.default[each.value.vpc_name].id
  route_table_ids   = [for route_table_name in each.value.route_table_names : data.aws_route_table.default[route_table_name].id]
  tags = merge({
    "Name" = each.value.vpcendpoint_name
  }, each.value.tags)
}

resource "aws_vpc_endpoint" "VPC_Endpoint_Interface" {
  for_each            = { for vpce in local.vpcendpoint_interface_optimize : "${data.aws_vpc.default[vpce.vpc_name].id}_${vpce.service_name}" => vpce }
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = each.value.private_dns_enabled
  service_name        = each.value.service_name
  vpc_id              = data.aws_vpc.default[each.value.vpc_name].id
  subnet_ids          = [for subnet_name in each.value.subnet_names : data.aws_subnet.default[subnet_name].id]
  security_group_ids  = [for securitygroup_name in each.value.securitygroup_names : data.aws_security_group.default[securitygroup_name].id]
  tags = merge({
    "Name" = each.value.vpcendpoint_name
  }, each.value.tags)
}
