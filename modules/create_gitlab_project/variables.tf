variable "project" {
  type = object({
    name                   = string
    path                   = string
    namespace_id           = string //id группы
    description            = optional(string, "")
    initialize_with_readme = optional(bool)
    default_branch         = optional(string)
    merge_method           = optional(string)
    use_custom_template    = optional(string, false)
    template_project_id    = optional(number)
    visibility_level       = optional(string, "public")
  })
}