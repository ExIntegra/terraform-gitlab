variable "gitlab_token" {
  description = "GitLab API token, supplied through TF_VAR_gitlab_token."
  type        = string
  sensitive   = true
  nullable    = false
}

variable "infrastructure" {
  type = map(object({
    parent_group     = optional(string)
    description      = optional(string, "")
    visibility_level = optional(string, "private")
    members          = optional(map(string), {})
    projects = optional(map(object({
      description            = optional(string, "")
      visibility_level       = optional(string, "private")
      initialize_with_readme = optional(bool, true)
      default_branch         = optional(string, "main")
      merge_method           = optional(string, "merge")
    })), {})
  }))
  default  = {}
  nullable = false
}