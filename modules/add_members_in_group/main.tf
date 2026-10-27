// Модуль для редактирования доступа к группе GitLab
resource "gitlab_group_membership" "members" {
  for_each     = var.members
  group_id     = var.group_id
  user_id      = each.value.user_id
  access_level = each.value.access_level
}