output "vpce_interface_arn" {
  description = "The arn of the Endpoint(Type : Interface)"
  value       = { for key, value in aws_vpc_endpoint.VPC_Endpoint_Interface : value.tags["Name"] => value.arn }
}

output "vpce_interface_service_name" {
  description = "The service_name of the Endpoint(Type : Interface)"
  value       = { for key, value in aws_vpc_endpoint.VPC_Endpoint_Interface : value.tags["Name"] => value.service_name }
}

output "vpce_interface_securitygroup_id" {
  description = "The security_group_ids name of the Endpoint(Type : Interface)"
  value       = { for key, value in aws_vpc_endpoint.VPC_Endpoint_Interface : value.tags["Name"] => value.security_group_ids }
}

output "vpce_interface_subnet_id" {
  description = "The subnet_ids name of the Endpoint(Type : Interface)"
  value       = { for key, value in aws_vpc_endpoint.VPC_Endpoint_Interface : value.tags["Name"] => value.subnet_ids }
}

output "vpce_gateweay_arn" {
  description = "The arn of the Endpoint(Type : Gateway)"
  value       = { for key, value in aws_vpc_endpoint.VPC_Endpoint_Gateway : value.tags["Name"] => value.arn }
}

output "vpce_gateweay_service_name" {
  description = "The service_name of the Endpoint(Type : Gateway)"
  value       = { for key, value in aws_vpc_endpoint.VPC_Endpoint_Gateway : value.tags["Name"] => value.service_name }
}