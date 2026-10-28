// для модуля get_id_gitlab_users
variable "usernames" {
  type = set(string)
}

// список шаблонных репозиториев
variable "temp_name_repo" {
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
  type     = map(map(string))
  default  = {}
  nullable = false
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
    use_custom_template    = optional(string)
    template_project_name  = optional(string)
    visibility_level       = optional(string)
  }))
}

// для модуля create_gitlab_group
variable "create_group" {
  type = map(object({
    description      = optional(string, "")
    visibility_level = optional(string, "private")
  }))
}