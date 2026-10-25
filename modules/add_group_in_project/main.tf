resource "gitlab_project_share_group" "qa_access" {
  project      = var.group_id.project_id
  group_id     = var.group_id.group_id
  group_access = var.group_id.access_level
}