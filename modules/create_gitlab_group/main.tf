data "gitlab_group" "parent" {
  for_each  = toset([for group in values(var.create_group) : group.parent_group if group.parent_group != null])
  full_path = each.value
}
resource "gitlab_group" "new_group" {
  for_each         = var.create_group
  parent_id        = each.value.parent_group == null ? null : data.gitlab_group.parent[each.value.parent_group].id
  name             = each.key
  path             = each.key
  description      = each.value.description
  visibility_level = each.value.visibility_level
}
