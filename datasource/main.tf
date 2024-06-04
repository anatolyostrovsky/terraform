provider "aws" {}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "my_vpcs" {}
data "aws_vpc" "my_prod_vpc" {
  tags = {
    Name = prod
  }
}

output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names
}

output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

output "data_aws_region_description" {
  value = data.aws_region.current.description
}
output "data_aws_region_name" {
  value = data.aws_region.current.name
}

output "aws_vpcs" {
  value = data.aws_vpcs.my_vpcs.ids
}

output "prod_vpc_id" {
  value = data.aws_vpc.my_prod_vpc.id
}

output "prod_vpc_cidr" {
  value = data.aws_vpc.my_prod_vpc.cidr_block
}
