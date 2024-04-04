resource "aws_iam_policy" "default" {
  for_each    = { for policy in var.policys : policy.name => policy }
  name        = each.value.name
  name_prefix = each.value.name_prefix
  description = each.value.description
  path        = each.value.path
  policy      = each.value.policy
  tags        = merge({ "Name" = each.value.name }, each.value.tags)
}