data "aws_vpc" "default" {
  for_each = toset(local.vpc_names_optimize)
  tags = {
    Name = each.key
  }
}

data "aws_route_table" "default" {
  for_each = toset(local.rouet_table_names_optimize)
  tags = {
    Name = each.key
  }
}

data "aws_subnet" "default" {
  for_each = toset(local.subnet_names_optimize)
  tags = {
    Name = each.key
  }
}

data "aws_security_group" "default" {
  for_each = toset(local.securitygroup_names_optimize)
  tags = {
    Name = each.key
  }
}




