#### Share Variable 
variable "securitygroups" {
  type = list(object({
    vpc_name           = optional(string, null)
    securitygroup_name = optional(string, null)
    description        = optional(string, "Security Group")
    rules = list(object({
      type        = optional(string, "ingress")
      protocol    = optional(string, null)
      portrange   = optional(string, null)
      source      = optional(string, null)
      description = optional(string, " ")
    }))
    tags = optional(map(string), null)
  }))
  default = []
}
