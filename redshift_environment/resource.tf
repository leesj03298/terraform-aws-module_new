
#### AWS Redshift Subnet Group ##################################################################################################
resource "aws_redshift_subnet_group" "default" {
  for_each   = { for subgrp in var.subnet_groups : subgrp.tf_identifier => subgrp }
  name       = each.value.subnet_group_name
  subnet_ids = [for subnet_name in each.value.subnet_names : data.aws_subnet.default[sub_identifier].id]

}

#### AWS Redshift Parameter Group ###############################################################################################
resource "aws_redshift_parameter_group" "default" {
  for_each    = { for pargrp in var.parameter_groups : pargrp.tf_identifier => pargrp }
  name        = each.value.paramget_group_name
  family      = each.value.family
  description = each.value.description
  dynamic "parameter" {
    for_each = { for parameter in each.value.parameter : parameter.name => parameter.value }
    content {
      name  = parameter.key
      value = parameter.value
    }
  }
}