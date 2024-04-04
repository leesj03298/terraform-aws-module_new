output "policys" {
  value = { for key, value in awsaws_iam_policy.default : key => value }
}