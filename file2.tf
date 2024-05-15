provider "aws" {}

variable "subnet_cidr_block" {
  description = "subnet CIDR BLOCK"
}

variable "vpc_cidr_block" {
  description = "vpc cidr block"
}

resource "aws_vpc" "dev-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name : "Developmet"
  }

}

resource "aws_subnet" "dev-subnet" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = "eu-west-1a"
  tags = {
    Name : "Developmet"
  }

}

output "dev-vpc-id" {
  value = aws_vpc.dev-vpc.id
}

output "dev-subnet-id" {
  value = aws_subnet.dev-subnet.id
}
