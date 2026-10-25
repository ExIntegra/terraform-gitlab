resource "gitlab_project_share_group" "qa_access" {
  project      = var.share_group.project_id
  group_id     = var.share_group.group_id
  group_access = var.share_group.access_level
}