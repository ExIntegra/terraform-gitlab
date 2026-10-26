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

variable "parent_group_path" {
    type = string
}

variable "usernames" {
    type = set(string)
}
variable "groups" {
    type = map(object({
        name = string
        path = string
        description = optional(string, "")
        members = map(string)
    }))
}

variable "shares" {
    type = map(object({
        project_key = string
        group_key = string
        access_level = string
    }))
}