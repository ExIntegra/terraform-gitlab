//получаем id родительской группы для создания дочерных элементов
data "gitlab_group" "parent" {
  full_path = var.parent_group_path
}

// получаем ids указанных шаблонов-проектов для последующего использования
data "gitlab_project" "templates" {
  for_each            = toset(var.temp_name_repo)
  path_with_namespace = "${var.temp_path}/${each.value}"
}