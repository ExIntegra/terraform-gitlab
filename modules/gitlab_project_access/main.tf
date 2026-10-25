resource "gitlab_group_membership" "team_member" {
  for_each     = var.team_members_usernames
  group_id     = var.create_group.group_id
  user_id      = var.team_members_usernames.user_id
  access_level = var.team_members_usernames.access_level
}

resource "gitlab_group_membership" "team_lead" {
  group_id     = var.create_group.group_id
  user_id      = var.team_lead_username.user_id
  access_level = var.team_lead_username.access_level
}