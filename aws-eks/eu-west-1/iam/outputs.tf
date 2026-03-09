output "user_access_keys" {
  value = { for user, access_key in aws_iam_access_key.user_access_keys : user => {
    access_key_id = access_key.id
    secret_key    = access_key.secret
  }}
  sensitive = true
}

output "user_iam_users" {
  value = aws_iam_user.users
}
