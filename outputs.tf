output "group_ids" {
  value = module.create-groups.group_id
}

output "project_ids" {
  value = {
    for name, id in var.project :
    name => module.projects[name].project_id
  }
}

output "user_ids" {
  value = module.get_user_ids
}


output "temp_project_ids" {
  value = { for name, p in data.gitlab_project.templates : name => p.id }
}