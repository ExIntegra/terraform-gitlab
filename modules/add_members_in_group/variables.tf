variable "infrastructure" {
  type = map(object({
    members = optional(map(string), {})
  }))
  nullable = false
  validation {
    condition = alltrue(flatten([
      for group in values(var.infrastructure) : [
        for role in values(group.members) :
        contains(["guest", "reporter", "developer", "maintainer", "owner"], role)
      ]
    ]))
    error_message = "Invalid group member access level."
  }
}
variable "group_ids" {
  type     = map(string)
  nullable = false
}
