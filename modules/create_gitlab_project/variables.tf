variable "project" {
  description = "Параметры создаваемого проекта"
  type = object({
    name                   = string
    path                   = string
    description            = optional(string, "")
    group_id               = string
    default_branch         = optional(string, "main")
    merge_method           = optional(string, "merge")
    visibility_level       = optional(string, "private")
    initialize_with_readme = optional(bool, false)
  })
}
