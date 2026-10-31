resource "gitlab_project" "project" {
  name                   = var.project.name
  path                   = var.project.path
  description            = var.project.description
  group_id               = var.project.group_id
  default_branch         = var.project.default_branch
  merge_method           = var.project.merge_method
  visibility_level       = var.project.visibility_level
  initialize_with_readme = var.project.initialize_with_readme
}
