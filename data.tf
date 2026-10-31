//получаем id родительской группы для создания дочерных элементов
data "gitlab_group" "parent" {
  full_path = var.parent_group_path
}