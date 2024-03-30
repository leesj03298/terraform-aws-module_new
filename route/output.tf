output "routes" {
  value = [for route in var.routes :
    "Rotue_Table_Name : ${route.route_table_name}, Destination : ${route.destination}, Target_Name : ${route.target_name}"
  ]
}
