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
    name                   = each.key
    path                   = each.key
    namespace_id           = module.create-groups.group_id[each.value.namespace_id]
    description            = coalesce(try(each.value.description, null), "Проект ${each.key}")
    initialize_with_readme = try(each.value.initialize_with_readme, false)
    default_branch         = try(each.value.default_branch, "main")
    merge_method           = try(each.value.merge_method, "merge")
  }
}

module "get_user_ids" {
  source   = "./modules/get_id_gitlab_users"
  user_ids = var.usernames
}

module "add_members_in_group" {
  source   = "./modules/add_members_in_group"
  for_each = var.create_group

  group_id = module.create-groups.group_id[each.key]
  members = {
    for name, role in var.members_group[each.key] :
    name => {
      user_id      = data.gitlab_user.user_ids[name].user_id
      access_level = role
    }
  }
}