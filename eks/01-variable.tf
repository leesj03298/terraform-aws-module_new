variable "eks_cluster" {
  type = list(object({
    tf_identifier           = optional(string, null)
    name                    = optional(string, null)
    role_name               = optional(string, null)
    endpoint_private_access = optional(bool, true)
    endpoint_public_access  = optional(bool, true)
    public_access_cidrs     = optional(list(string), ["0.0.0.0/0"])
    security_group_names    = optional(list(string), [])
    subnet_names            = optional(list(string), [])

    authentication_mode                         = optional(string, "API_AND_CONFIG_MAP")
    bootstrap_cluster_creator_admin_permissions = optional(bool, true)

    enabled_clsuter_log_types = optional(string, null)
    encryption_config         = optional(string, null)
    kubernetes_network_config = optional(object({
      service_ipv4_cidr = optional(string, null)
      ip_family         = optional(string, null)
    }), {})
    output_config = optional(object({
      control_plane_instance_type = optional(string, null)
      control_plane_placement     = optional(string, null)
      outpost_arns                = optional(string, null)
    }), {})
    version = optional(string, null)
    tags    = optional(map(string), {})
  }))
  default = []
}

variable "eks_addon" {
  type = list(object({
    cluster_name                = optional(string, null)
    addon_name                  = optional(string, null)
    addon_version               = optional(string, null)
    configuration_values        = optional(map(any), {})
    resolve_conflicts_on_create = optional(string, "OVERWRITE")
    resolve_conflicts_on_update = optional(string, "OVERWRITE")
    service_account_role_arn    = optional(string, null)
    preserve                    = optional(bool, false)
  }))
  default = []
}