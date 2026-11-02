locals {
  all_projects = flatten([
    for group_name, group in var.infrastructure : [
      for project_name, project in group.projects : merge(project, {
        group_name = group_name
        name       = project_name
      })
    ]
  ])

  projects = { for p in local.all_projects : "${p.group_name}/${p.name}" => p }
}

resource "gitlab_project" "project" {
  for_each               = local.projects
  name                   = each.value.name
  path                   = each.value.name
  namespace_id           = var.group_ids[each.value.group_name]
  description            = each.value.description
  visibility_level       = each.value.visibility_level
  initialize_with_readme = each.value.initialize_with_readme
  default_branch         = each.value.initialize_with_readme ? each.value.default_branch : null
  merge_method           = each.value.merge_method
}
