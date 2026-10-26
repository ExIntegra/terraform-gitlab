output "group_id" {
  value = {
    for name, group in gitlab_group.new_group :
    name => group.id
  }
}