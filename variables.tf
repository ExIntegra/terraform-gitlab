// для модуля get_id_gitlab_users
variable "usernames" {
  type = set(string)
}

// список шаблонных репозиториев
variable "temp_name_repo" {
  type = set(string)
}

variable "temp_path" {
  type = string
}

variable "token" {
  type      = string
  sensitive = true
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
  type     = map(map(string))
  default  = {}
  nullable = false
}

// для создания проекта
// используется в модуле create_gitlab_project
variable "project" {
  type = map(object({
    // ???
    namespace_id           = string
    description            = optional(string)
    initialize_with_readme = optional(bool, true)
    default_branch         = optional(string, "main")
    merge_method           = optional(string, "merge")
    use_custom_template    = optional(bool, false)
    temp_name              = optional(string)
    visibility_level       = optional(string, "private")
  }))
}

// для модуля create_gitlab_group
variable "create_group" {
  type = map(object({
    description      = optional(string, "")
    visibility_level = optional(string, "private")
  }))
}