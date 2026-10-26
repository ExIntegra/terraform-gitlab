// Общие настроки для Terraform, провайдера GitLab
terraform {
  required_version = "1.12.2"
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "19.4.1"
    }
  }
}

//------------- Блок провайдера (provider) для настройки подключения к GitLab -------------
provider "gitlab" {
  token = var.admin_token
}

variable "admin_token" {
  description = "Токен администратора GitLab для аутентификации"
  type        = string
  sensitive   = true
}

data "gitlab_group" "parent" {
  full_path = var.parent_group_path
}

module "groups" {
  source = "./modules/create_gitlab_group"
  create_group = var.groups
}

module "users" {
  source = "./modules/get_id_gitlab_users"
  team_members_usernames = var.usernames
}

module "projects" {
  source = "./modules/create_gitlab_project"
  project = var.project
}