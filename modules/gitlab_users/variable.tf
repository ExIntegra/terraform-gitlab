variable "team_members_usernames" {
  description = "Список участников команды для назначения в GitLab группу с уровнем доступа developer"
  type        = set(string)
}