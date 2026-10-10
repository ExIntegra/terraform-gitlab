
// Общие настроки для Terraform, провайдера GitLab
terraform {
  required_version = "1.12.2"
  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab"
    }
  }
}


//------------- Блок данных (data) для получения информации о существующих ресурсах в GitLab -------------

// Получение данных о родительской группе
data "gitlab_group" "parent_group" {
  full_path = "it-akron"
}

// Получение данных о пользователе с именем пользователя "ChefIvan"
// Дальше эти данные можно использовать для назначения прав доступа и других операций в GitLab
// В конкретном случае, мы используем данные о пользователе для назначения его в качестве
// участника группы с уровнем доступа "maintainer"
data "gitlab_user" "team_lead" {
  username = "ChefIvan"
}

// Получение данных о пользователях с именами пользователей "Maks", "Gleb" и "Daniil"
data "gitlab_user" "team_member" {
  for_each = toset(["Maks", "Gleb", "Daniil"])
  username = each.value
}

//------------- Блок переменных (variable) для хранения конфиденциальных данных -------------
// Переменная для хранения токена адмнистратора (PAT token) с описанием и пометкой как конфиденциальная
variable "admin_token" {
  description = "Owner PAT token"
  sensitive   = true
}

//------------- Блок провайдера (provider) для настройки подключения к GitLab -------------
provider "gitlab" {
  token    = var.admin_token
  base_url = "https://gitlab.com" // URL GitLab, можно изменить, в вашем случае используется локальный GitLab
}

//------------- Блок ресурсов (resource) для создания новых ресурсов в GitLab -------------
// Создание новой группы в GitLab с указанием родительской группы, имени, пути и описания
resource "gitlab_group" "it_acron" {
  parent_id         = data.gitlab_group.parent_group.id
  name              = "the_best_team"
  path              = "the_best_team"
  description       = "The Awesome Team provides awesome tech that makes our company shine!"
  wiki_access_level = "private" # make the Wiki only viewable by group members
}

// Назначение пользователя с именем пользователя "ChefIvan" в качестве участника группы с уровнем доступа "maintainer"
resource "gitlab_group_membership" "team_lead" {
  group_id     = gitlab_group.it_acron.id
  user_id      = data.gitlab_user.team_lead.id
  access_level = "maintainer"
}

resource "gitlab_group_membership" "team_member" {
  for_each    = data.gitlab_user.team_member // Создание участника группы для каждого пользователя из списка team_member
  group_id     = gitlab_group.it_acron.id
  user_id      = data.gitlab_user.team_member.id // Используем идентификатор пользователя из блока данных team_member
  access_level = "developer" 
}
// Создание нового проекта в GitLab с указанием имени, пути, описания и идентификатора группы
resource "gitlab_project" "project" {
  name         = "the_best_project"
  path         = "the_best_project"
  description  = "The Awesome Project provides awesome tech that makes our company shine!"
  namespace_id = gitlab_group.it_acron.id
}

// Создание правила одобрения для проекта, требующего одного одобрения
// от пользователя с именем пользователя "ChefIvan" перед слиянием Merge Request
resource "gitlab_project_approval_rule" "merge_request_approval" {
  project            = gitlab_project.project.id
  name               = "Merge Request Approval"
  approvals_required = 1
  user_ids           = [data.gitlab_user.team_lead.id]
}

// Создание защиты ветки "main" в проекте, запрещающей форсированные
// пуши и ограничивающей доступ к пушу и слиянию только для участников с уровнем доступа "maintainer"
resource "gitlab_branch_protection" "main_branch_protection" {
  project = gitlab_project.project.id
  branch = "main"
  push_access_level = "maintainer"
  merge_access_level = "maintainer"
  allow_force_push = false
}

// Создание переменной проекта в GitLab с указанием ключа, значения и параметров защиты, маскировки и скрытия
resource "gitlab_project_variable" "mySecretVariable" {
  project = gitlab_project.project.id
  key     = "MY_SECRET_VARIABLE"
  value   = "my_secret_value"
  protected = true
  masked    = true
  hidden   = true
}
