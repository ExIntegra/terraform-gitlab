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