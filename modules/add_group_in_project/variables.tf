variable "share_group" {
  type = object({
    project_id   = string
    group_id     = number
    access_level = string
  })
}