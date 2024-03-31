
variable "vpcendpoint_gateway" {
  type = list(object({
    vpcendpoint_name  = optional(string, null)
    vpc_name          = optional(string, null)
    service_name      = optional(string, null)
    route_table_names = optional(list(string), null)
    tags              = optional(map(string), {})
  }))
  default = []
}

variable "vpcendpoint_interface" {
  type = list(object({
    vpc_name            = optional(string, null)
    subnet_names        = optional(list(string), null)
    securitygroup_names = optional(list(string), null)
    service = optional(list(object({
      vpcendpoint_name    = optional(string, null)
      service_name        = optional(string, null)
      private_dns_enabled = optional(bool, true)
      tags                = optional(map(string), {})
    })), [])
  }))
  default = []
}