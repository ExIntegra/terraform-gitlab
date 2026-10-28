resource "gitlab_project_membership" "members" {
  for_each     = var.members
  project_id   = var.project_id
  user_id      = each.value.user_id
  access_level = each.value.access_level
}