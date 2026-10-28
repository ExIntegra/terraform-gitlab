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

  project = {
    name         = each.key
    path         = each.key
    namespace_id = module.create-groups.group_id[each.value.namespace_id]
    //попытается извлечь данные через try, если нет, то null
    //coalesce ловит null и выдает шаблон в переменную description
    description            = coalesce(try(each.value.description, null), "Проект ${each.key}")
    initialize_with_readme = try(each.value.initialize_with_readme, false)
    default_branch         = try(each.value.default_branch, "main")
    merge_method           = try(each.value.merge_method, "merge")
    use_custom_template    = try(each.value.use_custom_template, false)
    template_project_id    = try(each.value.template_project_id, null)
    visibility_level       = try(each.key.value.visibility_level, "public")
  }
}

data "gitlab_project" "templates" {
  for_each = toset(var.temp_name_repo)
  name     = each.value
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
      user_id      = module.get_user_ids[name].user_id //data.gitlab_user.user_ids[name].user_id
      access_level = role
    }
  }
}