locals {
  vpcendpoint_interface_optimize = flatten([for vpce_interface in var.vpcendpoint_interface :
    [for service in vpce_interface.service : merge(service, {
      vpc_name            = vpce_interface.vpc_name
      subnet_names        = vpce_interface.subnet_names
      securitygroup_names = vpce_interface.securitygroup_names
      })
  ]])
  vpc_names_optimize           = distinct(flatten([var.vpcendpoint_gateway[*].vpc_name, local.vpcendpoint_interface_optimize[*].vpc_name]))
  rouet_table_names_optimize   = distinct(flatten(var.vpcendpoint_gateway[*].route_table_names))
  subnet_names_optimize        = distinct(flatten(local.vpcendpoint_interface_optimize[*].subnet_names))
  securitygroup_names_optimize = distinct(flatten(local.vpcendpoint_interface_optimize[*].securitygroup_names))
}