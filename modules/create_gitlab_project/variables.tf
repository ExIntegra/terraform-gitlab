variable "infrastructure" {
  type = map(object({
    projects = optional(map(object({
      description            = optional(string, "")
      visibility_level       = optional(string, "private")
      initialize_with_readme = optional(bool, true)
      default_branch         = optional(string, "main")
      merge_method           = optional(string, "merge")
    })), {})
  }))
  nullable = false

  validation {
    condition = alltrue(flatten([
      for group in values(var.infrastructure) : [
        for project in values(group.projects) :
        contains(["private", "internal", "public"], project.visibility_level) &&
        contains(["merge", "rebase_merge", "ff"], project.merge_method)
      ]
    ]))
    error_message = "Invalid project visibility_level or merge_method."
  }
}
variable "group_ids" {
  type     = map(string)
  nullable = false
}
