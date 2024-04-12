output "roles" {
    value = aws_iam_role.default
}

output "role_policy_attachment" {
    value = aws_iam_role_policy_attachment.default
}