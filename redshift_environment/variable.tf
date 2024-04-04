
variable "subnet_groups" {
  description = "Create Resource : Redshift Subnet Group"
  type = list(object({
    tf_identifier     = optional(string, null)
    subnet_group_name = optional(string, null)
    subnet_names      = optional(list(string), [])
  }))
  default = []
}

variable "parameter_groups" {
  description = "Create Resource : Redshift Parameter Group"
  type = list(object({
    tf_identifier       = optional(string, null)
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