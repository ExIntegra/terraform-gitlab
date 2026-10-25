variable "project" {
    type = object({
        name                   = string // Имя проекта
        path                   = string // Путь проекта
        description            = optional(string) // Описание проекта
        namespace_id           = number // Идентификатор группы, в которой будет создан проект
        initialize_with_readme = bool   // Флаг для инициализации проекта с README файлом
        default_branch         = optional(string, "main")
        merge_method           = string // Метод слияния для проекта (например, "merge", "rebase", "ff")
    })
}