variable "project" {
  type = map(object({
    name                   = string
    path                   = string
    namespace_id           = string //id группы
    description            = optional(string, "")
    initialize_with_readme = optional(bool, false)
    default_branch         = optional(string, "main")
    merge_method           = optional(string, "merge")
  }))
}