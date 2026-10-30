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
  //token = через переменную окружения GITLAB_TOKEN
}

module "create-groups" {
  source       = "./modules/create_gitlab_group"
  create_group = var.create_group
  parent_id    = data.gitlab_group.parent.group_id
}


module "projects" {
  source   = "./modules/create_gitlab_project"
  for_each = var.project
  # gitlab_url   = "https://repo.vnov.acron.ru"
  # temp_path    = "terraform-acron-web/templates"
  # import_token = var.token

  project = {
    name           = each.key
    path           = each.key
    namespace_id   = module.create-groups.group_id[each.value.namespace_id]
    description    = coalesce(each.value.description, "Проект ${each.key}")
    default_branch = each.value.default_branch
    merge_method   = each.value.merge_method
    # use_custom_template = each.value.use_custom_template
    temp_name        = each.value.temp_name
    visibility_level = each.value.visibility_level
  }
}

module "get_user_ids" {
  source   = "./modules/get_id_gitlab_users"
  user_ids = toset(var.usernames)
}

module "add_members_in_group" {
  source   = "./modules/add_members_in_group"
  for_each = var.create_group

  group_id = module.create-groups.group_id[each.key]
  members = {
    //если не находим в map участников, то отдаем пустой список {}
    for name, role in lookup(var.members_group, each.key, {}) :
    name => {
      user_id      = module.get_user_ids.user.ids[name]
      access_level = role
    }
  }
}

data "gitlab_project_variables" "all" {
  project = "acron-web/client/acron-web-client-shell"
}

output "all_variables_gitlab" {
  value = data.gitlab_project_variables.all.variables
}

# resource "gitlab_project_variable" "variable" {
#   project = "terraform-gitlab-test/existing_project"
#   key     = "variable_5"
#   value   = "15"
# }

import {
  to = gitlab_project.monitoring
  id = "terraform-gitlab-test/existing_project"
}