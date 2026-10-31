// Общие настроки для Terraform, провайдера GitLab
terraform {
  required_version = "1.12.2"

  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 3.18"
    }
  }
}

provider "gitlab" {
  base_url = "https://repo.vnov.acron.ru/"
}

module "create-groups" {
  source       = "./modules/create_gitlab_group"
  create_group = var.create_group
  parent_id    = data.gitlab_group.parent.group_id
}

/*
[TODO] Если создаётся пустой Git-репозиторий, ветки main может ещё не существовать.
В GitLab Provider известны случаи, когда настройка default_branch без инициализации
репозитория приводила к ошибкам изменения ветки.
*/
module "projects" {
  source   = "./modules/create_gitlab_project"
  for_each = var.project
  project = each.value
  name = each.key
  group_id = module.create_gitlab_group.group_id
}

module "get_user_ids" {
  source   = "./modules/get_id_gitlab_users"
  user_ids = toset(var.create_group[*])
}

module "add_members_in_group" {
  source   = "./modules/add_members_in_group"
  for_each = var.create_group

  group_id = module.create-groups.group_id[each.key]
  members = {
    //если не находим в map участников, то отдаем пустой список {}
    for name, role in lookup(var.create_group[], each.key, {}) :
    name => {
      user_id      = module.get_user_ids[name]
      access_level = role
    }
  }
}