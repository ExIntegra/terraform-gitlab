# Terraform: GitLab infrastructure

Три отдельных модуля: groups, projects, members. Все получают общую структуру infrastructure. Группы создаются в существующей parent_group (полный путь) либо на верхнем уровне. Участники задаются как username = role. Проекты получают namespace_id из outputs модуля groups; ключи результатов имеют вид group/project. Одинаковые имена проектов в разных группах поддерживаются.

## Запуск

Требуется Terraform 1.12.2 и провайдер gitlabhq/gitlab ~> 3.18 (версия сохранена). Скопируйте terraform.tfvars.example в terraform.tfvars и измените группы, проекты и пользователей. Неуказанные projects и members означают пустые карты.

Передайте токен через переменную окружения TF_VAR_gitlab_token (чувствительная входная переменная Terraform). Адрес GitLab сохранён в provider.base_url в main.tf; при необходимости замените его адресом своего API (например https://gitlab.example.com/api/v4/). Токен и локальный terraform.tfvars не публикуются.

```sh
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
```

После проверки плана можно выполнить terraform apply. Если initialize_with_readme = false, default_branch не передаётся: ветку нужно создать отдельно.

## Переход с прежней конфигурации

Интерфейсы create_group/project/parent_group_path заменены на infrastructure, а адреса ресурсов изменились: module.groups.gitlab_group.new_group["backend"], module.projects.gitlab_project.project["backend/api"], module.members.gitlab_group_membership.members["backend/ivan"]. Для существующего state сначала сопоставьте прежние адреса через terraform state list и выполните подходящие terraform state mv или import. Универсальная миграция не задана, поскольку прежняя корневая конфигурация содержит несогласованные ссылки. Не применяйте план с неожиданным удалением существующих ресурсов.

Выходы: group_ids и project_ids. Дополнительные прежние вспомогательные модули сохранены, но корневой модуль их не вызывает.
