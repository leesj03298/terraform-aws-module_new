# Terraform AWS Module - LEE SEUNG JOON : route


## Example Template
```HCL
module "route" {
  source      = "../../../../terraform-aws-module_new//route"
  routes = [
    {
      route_table_name       = "rtb-an2-eks-dev-app-lb-01"
      target_type            = "internet_gateway"
      target_name            = "igw-an2-eks-dev-app-01"
      destination            = "0.0.0.0/0"
    },
  ]
}
```