
variable "routes" {
  type = list(object({
    route_table_name = optional(string, null)
    target_type      = optional(string, null)
    target_name      = optional(string, null)
    destination      = optional(string, null)
  }))
  default = []
}
