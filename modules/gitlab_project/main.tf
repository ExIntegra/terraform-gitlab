// Создание нового проекта в GitLab с указанием имени, пути, описания и идентификатора группы
resource "gitlab_project" "project" {
  name                   = var.create_project.name
  path                   = var.create_project.path
  description            = var.create_project.description
  namespace_id           = var.create_project.namespace_id
  initialize_with_readme = var.create_project.initialize_with_readme
  default_branch         = var.create_project.default_branch
  merge_method           = var.create_project.merge_method
}