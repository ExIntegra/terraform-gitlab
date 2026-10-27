data "gitlab_user" "users" {
  for_each = var.user_ids
  username = each.value
}
