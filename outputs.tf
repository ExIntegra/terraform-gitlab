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

output "gitlab_ids" {
  value = {
    for name, user in data.gitlab_user.user_ids : name => user.user_id
  }
}
