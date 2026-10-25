variable "members" {
  type = map(object({
    user_id      = number
    access_level = string
  }))
}

variable "group_id" {
  type = number
}