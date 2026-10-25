variable "team_members_usernames" {
  type = object({
    for_each = set(string)
    user_id = each.value.id
    group_id = number
    access_level = string
  })
}

variable "team_lead_username" {
  type = object({
    name = string
    user_id = name.id
    group_id = number
    access_level = string
  })
}