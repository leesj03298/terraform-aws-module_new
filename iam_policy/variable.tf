variable "policys" {
  type = list(object({
    description = optional(string, null)
    name        = optional(string, null)
    name_prefix = optional(string, null)
    path        = optional(string, "/")
    policy      = optional(string, null)
    tags        = optional(map(string), {})
  }))
  default = []
}