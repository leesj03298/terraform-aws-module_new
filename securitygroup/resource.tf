data "aws_region" "current" {}

### AWS Security Group
resource "aws_security_group" "default" {
  for_each    = { for scg in var.securitygroups : scg.securitygroup_name => scg }
  vpc_id      = data.aws_vpc.default[each.value.vpc_name].id
  name        = each.value.securitygroup_name
  description = each.value.description
  tags        = merge({ "Name" = each.value.securitygroup_name }, each.value.tags)
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

locals {
  scg_ids                    = { for key, value in aws_security_group.default : key => value.id }
}

resource "aws_security_group_rule" "sgr_cidr_blocks" {
  for_each = { for rule in local.security_group_rules_optimize : "${rule.securitygroup_name}_${rule.portrange}_${rule.source}" => rule
  if can(regex("[0-9]+.[0-9]+.[0-9]+.[0-9]+/[0-9]+", rule.source)) }
  security_group_id        = local.scg_ids[each.value.securitygroup_name]
  type                     = each.value.type
  from_port                = each.value.protocol == "icmp" ? -1 : split("-", each.value.portrange)[0]
  to_port                  = each.value.protocol == "icmp" ? -1 : can(split("-", each.value.portrange)[1]) ? split("-", each.value.portrange)[1] : split("-", each.value.portrange)[0]
  protocol                 = each.value.protocol
  cidr_blocks              = [each.value.source]
  description              = each.value.description
  source_security_group_id = null
  ipv6_cidr_blocks         = null
  prefix_list_ids          = null
}

resource "aws_security_group_rule" "sgr_source_security_group_id" {
  for_each = { for rule in local.security_group_rules_optimize : "${rule.securitygroup_name}_${rule.portrange}_${rule.source}" => rule
  if can(regex("[0-9a-zA-Z]+-", rule.source)) }
  security_group_id        = local.scg_ids[each.value.securitygroup_name]
  type                     = each.value.type
  from_port                = each.value.protocol == "icmp" ? -1 : split("-", each.value.portrange)[0]
  to_port                  = each.value.protocol == "icmp" ? -1 : can(split("-", each.value.portrange)[1]) ? split("-", each.value.portrange)[1] : split("-", each.value.portrange)[0]
  protocol                 = each.value.protocol
  source_security_group_id = local.scg_ids[each.value.source]
  description              = each.value.description
  cidr_blocks              = null
  ipv6_cidr_blocks         = null
  prefix_list_ids          = null
}