variable "project" {
  type = object({
    name                   = string
    path                   = string
    namespace_id           = number
    description            = optional(string, "")
    initialize_with_readme = optional(bool, true)
    default_branch         = optional(string, "main")
    merge_method           = optional(string, "merge")
  })
}