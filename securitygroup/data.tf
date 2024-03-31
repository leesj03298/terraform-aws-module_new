data "aws_vpc" "default" {
  for_each = { for scg in var.securitygroups : scg.vpc_name => scg }
  tags = {
    Name = each.value.vpc_name
  }
}