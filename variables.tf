// получаем id заранее созданной родительской группы
// для модуля create_gitlab_group
// опционально?
variable "parent_group_path" {
  type = string
}

// для создания проекта
// используется в модуле create_gitlab_project
variable "project" {
  type = map(object({
    // ???
    namespace_id           = string
    description            = optional(string)
    initialize_with_readme = optional(bool, false)
    default_branch         = optional(string, "main")
    merge_method           = optional(string, "merge")
    visibility_level       = optional(string, "private")
  }))
}

// для модуля create_gitlab_group
variable "create_group" {
  description = "Настройки создаваемых групп GitLab и их участников"

  type = map(object({
    description      = optional(string, "")
    visibility_level = optional(string, "private")
    members          = optional(map(string), {})
  }))

  default  = {}
  nullable = false

  // Проверка ролей участников группы
  validation {
    condition = alltrue([
      for _, group in var.create_group : alltrue([
        for _, role in group.members :
        contains(["guest", "reporter", "developer", "maintainer", "owner"], role)
      ])
    ])

    error_message = "Недопустимая роль пользователя GitLab. Допустимые роли: guest, reporter, developer, maintainer, owner."
  }

  // Проверка видимости групп
  validation {
    condition = alltrue([
      for _, group in var.create_group :
      contains(["private", "internal", "public"], group.visibility_level)
    ])

    error_message = "Допустимые значения visibility_level: private, internal, public."
  }
}