output "project_id" {
  value = { for key, project in gitlab_project.project : key => project.id }
}
