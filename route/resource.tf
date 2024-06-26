data "aws_region" "current" {}

### AWS Security Group
# resource "aws_route" "default" {
#   for_each               = { for rtbr in var.routetable_rules : join("_", [rtbr.route_table_identifier, rtbr.destination, rtbr.target]) => rtbr }
#   route_table_id         = var.rtb_ids[each.value.route_table_identifier]
#   destination_cidr_block = each.value.destination
#   # destination_ipv6_cidr_block = 
#   # destination_prefix_list_id = 
#   carrier_gateway_id = try(var.cagw_ids[each.value.target], null)
#   # core_network_arn = 
#   # egress_only_gateway_id  =
#   gateway_id     = try(var.igw_ids[each.value.target], null)
#   nat_gateway_id = try(var.ngw_ids[each.value.target], null)
#   # local_gateway_id = 
#   network_interface_id = try(var.eni_ids[each.value.target], null)
#   transit_gateway_id = try(var.tgw_ids[each.value.target], null)
#   # vpc_endpoint_id  =
#   vpc_peering_connection_id = try(var.pcx_ids[each.value.target], null)
# }

resource "aws_route" "default" {
  for_each               = { for rtbr in var.routes : join("_", [data.aws_route_table.default[rtbr.route_table_name].id, rtbr.destination]) => rtbr if local.create_route }
  route_table_id         = data.aws_route_table.default[each.value.route_table_name].id
  gateway_id             = try(data.aws_internet_gateway.default[each.value.target_name].id, null)
  nat_gateway_id         = try(data.aws_nat_gateway.default[each.value.target_name].id, null)
  destination_cidr_block = each.value.destination
}