output "policys" {
  value = { for key, value in aws_iam_policy.default : key => value }
}