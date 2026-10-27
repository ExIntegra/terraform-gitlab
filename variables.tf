// для модуля get_id_gitlab_users
variable "usernames" {
  type = set(string)
}

// получаем id заранее созданной родительской группы
// для модуля create_gitlab_group
// опционально?
variable "parent_group_path" {
  type = string
}

// для добавления участников в группы
// используется в модуле 
// содержит name group -> { nick -> role }
variable "members_group" {
  type = map(map(string))
}

// для создания проекта
// используется в модуле create_gitlab_project
variable "project" {
  type = map(object({
    namespace_id           = string
    description            = optional(string)
    initialize_with_readme = optional(bool)
    default_branch         = optional(string)
    merge_method           = optional(string)
  }))
}

// для модуля 
variable "create_group" {
  type = map(object({
    description      = optional(string, "")
    visibility_level = optional(string, "private")
  }))
}