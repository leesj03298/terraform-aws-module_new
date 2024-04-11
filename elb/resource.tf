
#### Object Optimize ############################################################################################################
locals {
  vpc_name_optimize            = distinct(var.target_group[*].vpc_name)
  subnet_names_optimize        = distinct(flatten([var.application_load_balancer[*].subnet_mapping[*].subnet_name, var.network_load_balancer[*].subnet_mapping[*].subnet_name]))
  security_group_name_optimize = distinct(flatten([var.application_load_balancer[*].security_group_names, var.network_load_balancer[*].security_group_names]))
}

#### Data Block #################################################################################################################
data "aws_vpc" "default" {
  for_each = toset(local.vpc_name_optimize)
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
  for_each = toset(local.security_group_name_optimize)
  tags = {
    Name = each.key
  }
}

#### Resource Block #################################################################################################################
##### Application Load Balancer #####################################################################################################
resource "aws_lb" "application_load_balancer" {
  for_each           = { for alb in var.application_load_balancer : alb.tf_identifier => alb if alb.tf_identifier != null }
  load_balancer_type = "application"
  name               = each.value.name
  internal           = each.value.internal
  security_groups    = [for security_group_name in each.value.security_group_names : data.aws_security_group.default[security_group_name].id]
  dynamic "subnet_mapping" {
    for_each = each.value.subnet_mapping
    content {
      subnet_id            = data.aws_subnet.default[subnet_mapping.value.subnet_name].id
      allocation_id        = subnet_mapping.value.allocation_id
      ipv6_address         = subnet_mapping.value.ipv6_address
      private_ipv4_address = subnet_mapping.value.private_ipv4_address
    }
  }
  dynamic "access_logs" {
    for_each = each.value.access_logs
    content {
      bucket  = access_logs.value.bucket_id
      prefix  = access_logs.value.prefix
      enabled = access_logs.value.enabled
    }
  }
  dynamic "connection_logs" {
    for_each = each.value.connection_logs
    content {
      bucket  = access_logs.value.bucket_id
      prefix  = access_logs.value.prefix
      enabled = access_logs.value.enabled
    }
  }
  tags = merge({ "Name" = each.value.name }, each.value.tags)
}

##### Network Load Balancer #########################################################################################################
resource "aws_lb" "network_load_balancer" {
  for_each           = { for nlb in var.network_load_balancer : nlb.tf_identifier => nlb if nlb.tf_identifier != null }
  load_balancer_type = "network"
  name               = each.value.name
  internal           = each.value.internal
  security_groups    = [for security_group_name in each.value.security_group_names : data.aws_security_group.default[security_group_name].id]
  dynamic "subnet_mapping" {
    for_each = each.value.subnet_mapping
    content {
      subnet_id            = data.aws_subnet.default[subnet_mapping.value.subnet_name].id
      allocation_id        = subnet_mapping.value.allocation_id
      ipv6_address         = subnet_mapping.value.ipv6_address
      private_ipv4_address = subnet_mapping.value.private_ipv4_address
    }
  }
  tags = merge({ "Name" = each.value.name }, each.value.tags)
}

##### Target Group ##################################################################################################################
resource "aws_lb_target_group" "default" {
  for_each    = { for tg in var.target_group : tg.tf_identifier => tg if tg.tf_identifier != null }
  name        = each.value.name
  protocol    = upper(each.value.protocol)
  port        = each.value.port
  target_type = each.value.target_type
  vpc_id      = data.aws_vpc.default[each.value.vpc_name].id
  tags        = merge({ "Name" = each.value.name }, each.value.tags)
}

##### Target Group ##################################################################################################################
# resource "aws_lb_target_group_attachment" "this" {
#   for_each = { for TARGET_GROUP_ATTACHMENT in local.TARGET_GROUP_ATTACHMENT_LIST : "${TARGET_GROUP_ATTACHMENT.target_group_attachment_identifier}" => TARGET_GROUP_ATTACHMENT
#   if TARGET_GROUP_ATTACHMENT.target_type == "instance" }
#   target_group_arn = lookup(aws_lb_target_group.this["${each.value.target_group_identifier}"], "arn", null)
#   target_id        = var.ec2_id["${local.share_tags["ec2"].Name}-${each.value.target_id}"]
#   port             = lookup(each.value, "port", null)
# }