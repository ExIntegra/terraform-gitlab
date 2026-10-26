variable "create_group" {
  type = map(object({
    name        = string
    path        = string
    description = string
  }))
}

variable "parent_id" {
  type = number
}