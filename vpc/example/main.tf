

module "example_vpc" {
  source = "../../../terraform-aws-module_new/vpc"
  vpcs = [
    {
      tf_identifier         = "exm-test-01"
      vpc_name              = "vpc-an2-exm-dev-test-01"
      cidr_block            = "10.10.0.0/23"
      igw_enable            = true
      internet_gateway_name = "igw-an2-exm-dev-test-01"
    }
  ]
  subnets = [
    {
      tf_identifier                = "exm-test-pub-01a"
      vpc_name                     = "vpc-an2-exm-dev-test-01"
      subnet_name                  = "sub-an2-exm-dev-test-pub-01a"
      availability_zone            = "a"
      cidr_block                   = "10.10.0.0/27"
      association_route_table_name = "rtb-an2-exm-dev-test-pub-01a"
    },
    {
      tf_identifier                = "exm-test-pub-01c"
      vpc_name                     = "vpc-an2-exm-dev-test-01"
      subnet_name                  = "sub-an2-exm-dev-test-pub-01c"
      availability_zone            = "c"
      cidr_block                   = "10.10.0.32/27"
      association_route_table_name = "rtb-an2-exm-dev-test-pub-01c"
    },
  ]
  route_tables = [
    {
      tf_identifier    = "exm-test-pub-01a"
      vpc_name         = "vpc-an2-exm-dev-test-01"
      route_table_name = "rtb-an2-exm-dev-test-pub-01a"
    },
    {
      tf_identifier    = "exm-test-pub-01c"
      vpc_name         = "vpc-an2-exm-dev-test-01"
      route_table_name = "rtb-an2-exm-dev-test-pub-01c"
    },
  ]
}