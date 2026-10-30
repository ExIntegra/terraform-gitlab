# variable "gitlab_url" {
#   type = string
# }

# variable "import_token" {
#   type      = string
#   sensitive = true
# }

# variable "temp_path" {
#   type    = string
#   default = "terraform-acron-web/templates"
# }

# variable "temp_name_repo" {
#   description = "Список доступных шаблонов для проверки имён"
#   type        = list(string)
#   default     = []
# }

variable "project" {
  description = "Параметры создаваемого проекта"
  type = object({
    name             = string
    path             = string
    description      = optional(string, "")
    namespace_id     = string
    default_branch   = optional(string, "main")
    merge_method     = optional(string, "merge")
    visibility_level = optional(string, "private")
    temp_name        = optional(string)
  })
}
