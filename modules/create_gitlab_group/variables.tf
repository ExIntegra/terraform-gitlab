variable "create_group" {
  type = map(object({
    description      = optional(string, "")
    visibility_level = optional(string, "private")
  }))

  validation {
    condition = alltrue([
      for _, group in var.create_group :
      contains(["private", "public", "internal"], group.visibility_level)
    ])

    error_message = "Допустимые значения visibility_level: private, internal, public."
  }
}

variable "parent_id" {
  type = number
}
