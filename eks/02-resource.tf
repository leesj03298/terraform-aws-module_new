data "aws_region" "current" {}
#### Object Optimize ############################################################################################################
locals {
  subnet_names_optimize          = distinct(flatten([var.eks_cluster[*].subnet_names]))
  security_groups_names_optimize = distinct(flatten([var.eks_cluster[*].security_group_names]))
  role_names_optimize            = distinct(flatten([var.eks_cluster[*].role_name]))
}

#### Data Block #################################################################################################################
data "aws_subnet" "default" {
  for_each = toset(local.subnet_names_optimize)
  tags = {
    Name = each.key
  }
}

data "aws_security_group" "default" {
  for_each = toset(local.security_groups_names_optimize)
  tags = {
    Name = each.key
  }
}

data "aws_iam_role" "default" {
  for_each = toset(local.role_names_optimize)
  name     = each.key
}


#### Resource Block #################################################################################################################
##### Application Load Balancer #####################################################################################################
resource "aws_eks_cluster" "default" {
  for_each = { for eks in var.eks_cluster : eks.tf_identifier => eks if eks.tf_identifier != null }
  name     = each.value.name
  role_arn = data.aws_iam_role.default[each.value.role_name].arn
  vpc_config {
    endpoint_private_access = each.value.endpoint_private_access
    endpoint_public_access  = each.value.endpoint_public_access
    public_access_cidrs     = each.value.public_access_cidrs
    security_group_ids      = [for security_group_name in each.value.security_group_names : data.aws_security_group.default[security_group_name].id]
    subnet_ids              = [for subnet_name in each.value.subnet_names : data.aws_subnet.default[subnet_name].id]
  }
  access_config {
    authentication_mode                         = each.value.authentication_mode
    bootstrap_cluster_creator_admin_permissions = each.value.bootstrap_cluster_creator_admin_permissions
  }
  version = each.value.version
  tags    = merge({ "Name" = each.value.name }, each.value.tags)
}


data "tls_certificate" "default" {
  for_each                    = { for eks in var.eks_cluster : eks.tf_identifier => eks if eks.tf_identifier != null }
  url = aws_eks_cluster.default[each.key].identity[0].oidc[0].issuer
}


resource "aws_iam_openid_connect_provider" "default" {
  for_each        = { for eks_cluster in var.eks_cluster : eks_cluster.tf_identifier => eks_cluster }
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.default[each.key].certificates[0].sha1_fingerprint]
  # thumbprint_list = [data.external.thumbprint.result.thumbprint]
  url             = aws_eks_cluster.default[each.value.tf_identifier].identity.0.oidc.0.issuer
}

# resource "aws_eks_addon" "default" {
#   for_each                    = { for eks_addon in var.eks_addon : join("-", [eks_addon.cluster_name, eks_addon.addon_name]) => eks_addon if eks_addon.identifier != null }
#   cluster_name                = each.value.cluster_name
#   addon_name                  = each.value.addon_name
#   addon_version               = each.value.addon_version
#   configuration_values        = jsonencode(each.value.configuration_values)
#   resolve_conflicts_on_create = each.value.resolve_conflicts_on_create
#   resolve_conflicts_on_update = each.value.resolve_conflicts_on_update
#   service_account_role_arn    = each.value.service_account_role_arn
#   preserve                    = each.value.preserve

#   depends_on = [
#     aws_eks_cluster.default
#   ]
# }


# data "external" "thumbprint" {
#   program = ["${path.module}/thumbprint.sh", data.aws_region.current.name]
# }

