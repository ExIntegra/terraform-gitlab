variable "project" {
  type = object({
    name                   = string
    path                   = string
    namespace_id           = string //id группы
    description            = optional(string, "")
    initialize_with_readme = optional(bool)
    default_branch         = optional(string)
    merge_method           = optional(string)
  })
}