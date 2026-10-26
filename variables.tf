variable "project" {
  type = map(object({
    name                   = string
    path                   = string
    namespace_id           = string //id группы
    description            = optional(string, "")
    initialize_with_readme = optional(bool, true)
    default_branch         = optional(string, "main")
    merge_method           = optional(string, "merge")
  }))
}

# variable "usernames" {
#     type = set(string)
# }

# variable "groups" {
#     type = map(object({
#         name = string
#         path = string
#         description = optional(string, "")
#         members = map(string)
#     }))
# }

variable "create_group" {
  type = map(object({
    name        = string
    path        = optional(string)
    description = optional(string, "")
  }))
}

# variable "shares" {
#     type = map(object({
#         project_key = string
#         group_key = string
#         access_level = string
#     }))
# }

variable "gitlab_token" {
  type = string
}

variable "parent_group_path" {
  type = string
}