data "aws_subnet" "default" {
  for_each = toset(distinct(flatten(var.subnet_groups[*].subnet_names)))
  tags = {
    Name = each.key
  }
}