data "gitlab_user" "users" {
  for_each = var.team_members_usernames
  username = each.value
}
