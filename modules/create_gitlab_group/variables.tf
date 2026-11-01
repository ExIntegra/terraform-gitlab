variable "create_group" {
  type = map(object({
    parent_group     = optional(string)
    description      = optional(string, "")
    visibility_level = optional(string, "private")
  }))

  validation {
    condition = alltrue([
      for group in values(var.create_group) :
      group.parent_group == null ? true : trimspace(group.parent_group) != ""
    ])
    error_message = "Parent group path must not be empty."
  }

  validation {
    condition = alltrue([
      for _, group in var.create_group :
      contains(["private", "public", "internal"], group.visibility_level)
    ])

    error_message = "Допустимые значения visibility_level: private, internal, public."
  }
}
