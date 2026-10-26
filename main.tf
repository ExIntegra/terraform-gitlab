// Общие настроки для Terraform, провайдера GitLab
terraform {
  required_version = "1.16.5"

  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 3.18"
    }
  }
}

provider "gitlab" {
  base_url = "https://repo.vnov.acron.ru/"
  token    = var.gitlab_token //передаем ТОЛЬКО через env
}

//получаем id родительской группы для создания дочерных элементов
data "gitlab_group" "parent" {
  full_path = var.parent_group_path
}

module "create-groups" {
  source       = "./modules/create_gitlab_group"
  create_group = var.create_group
  parent_id    = data.gitlab_group.parent.group_id
}

module "projects" {
  source   = "./modules/create_gitlab_project"
  for_each = var.project

  project = {
    name                   = each.value.name
    path                   = coalesce(each.value.path, each.key)
    namespace_id           = module.groups.group_id[each.value.namespace]
    description            = each.value.description
    initialize_with_readme = each.value.initialize_with_readme
    default_branch         = each.value.default_branch
    merge_method           = each.value.merge_method
  }
}
