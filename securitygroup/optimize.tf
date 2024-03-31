locals {
  security_group_rules_optimize = flatten([for scgs in var.securitygroups : [
    for rule in scgs.rules : merge(rule, { securitygroup_name = scgs.securitygroup_name })
  ]])
}