data "aws_vpc" "default" {
  for_each = toset(var.securitygroups[*].vpc_name)
  tags = {
    Name = each.key
  }
}




