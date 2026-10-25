variable "create_group" {
  type = object({
    parent_id   = number
    name        = string
    path        = string
    description = string
  })
}