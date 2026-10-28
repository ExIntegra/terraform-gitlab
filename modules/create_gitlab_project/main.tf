// Создание нового проекта в GitLab с указанием имени, пути, описания и идентификатора группы
resource "gitlab_project" "project" {
  name                   = var.project.name
  path                   = var.project.path
  description            = var.project.description
  namespace_id           = var.project.namespace_id
  initialize_with_readme = var.project.initialize_with_readme
  default_branch         = var.project.default_branch
  merge_method           = var.project.merge_method
  use_custom_template    = var.project.use_custom_template
  // if use_custom_template == true ; then var.project.template_project_id ; else null
  template_project_id    = var.project.use_custom_template ? var.project.template_project_id : null
  visibility_level       = var.project.visibility_level

  lifecycle {
    precondition {
      condition = ! var.project.use_custom_template || var.project.template_project_id != null
      error_message = "Не указан var.project.use_custom_template = true или id группы в var.project.template_project_id"
    }
  }
}