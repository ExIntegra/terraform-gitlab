variable "group_id" {
  type = object({
    project_id   = number
    group_id     = number
    access_level = string
  })
}