// Создание нового проекта в GitLab с указанием имени, пути, описания и идентификатора группы
resource "gitlab_project" "project" {
  name                   = var.project.name
  path                   = var.project.path
  description            = var.project.description
  namespace_id           = var.project.namespace_id
  initialize_with_readme = var.project.initialize_with_readme
  default_branch         = var.project.default_branch
  merge_method           = var.project.merge_method
}