variable "create_group" {
  type = map(object({
    description      = optional(string)
    visibility_level = optional(string)
  }))
}

variable "parent_id" {
  type = number
}
