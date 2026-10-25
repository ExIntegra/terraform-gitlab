// Создание новой группы в GitLab с указанием родительской группы, имени, пути и описания
resource "gitlab_group" "it_acron" {
  parent_id   = var.create_group.parent_id
  name        = var.create_group.name
  path        = var.create_group.path
  description = var.create_group.description
}