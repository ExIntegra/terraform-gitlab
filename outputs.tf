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