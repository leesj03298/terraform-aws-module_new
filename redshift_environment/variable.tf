
variable "subnet_groups" {
  description = "Create Resource : Redshift Subnet Group"
  type = list(object({
    subnet_group_name = optional(string, null)
    subnet_names      = optional(list(string), [])
    description       = optional(string, "Managed by Terraform")
    tags              = optional(map(string), {})
  }))
  default = []
}

variable "parameter_groups" {
  description = "Create Resource : Redshift Parameter Group"
  type = list(object({
    paramget_group_name = optional(string, null)
    family              = optional(string, "redshift-1.0")
    description         = optional(string, "Managed by Terraform")
    parameter = optional(list(object({
      name  = string
      value = string
    })), [])
  }))
  default = []
}