variable "project_id" {
  type = number
}

variable "members" {
  type = map(object({
    user_id      = number
    access_level = string
  }))
}
