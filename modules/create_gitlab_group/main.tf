// Создание новой группы в GitLab с указанием родительской группы, имени, пути и описания
resource "gitlab_group" "new_group" {
  for_each         = var.create_group
  parent_id        = var.parent_id
  name             = each.value.name
  path             = each.value.path
  description      = each.value.description
  visibility_level = "public"
}