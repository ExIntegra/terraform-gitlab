resource "gitlab_group" "new_group" {
  for_each         = var.create_group
  parent_id        = var.parent_id
  name             = each.key
  path             = each.key
  description      = each.value.description
  visibility_level = coalesce(try(each.value.visibility_level, null), "public")
}
