provider "aws" {}

variable "vpc_cidr_blocks" {}
variable "subnet_cidr_blocks" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "my_ip" {}
variable "instance_type" {}
variable "my_public_key_location" {}


resource "aws_vpc" "new-vpc" {
  cidr_block = var.vpc_cidr_blocks
  tags = {
    Name : "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "dev-subnet" {
  vpc_id            = aws_vpc.new-vpc.id
  cidr_block        = var.subnet_cidr_blocks
  availability_zone = var.avail_zone
  tags = {
    Name : "${var.env_prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "my-app-igw" {
  vpc_id = aws_vpc.new-vpc.id
  tags = {
    Name : "${var.env_prefix}-igw"
  }
}


resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.new-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-app-igw.id
  }
  tags = {
    Name : "${var.env_prefix}-route_table"
  }
}

resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id      = aws_subnet.dev-subnet.id
  route_table_id = aws_route_table.myapp-route-table.id
}


resource "aws_security_group" "myproject-sg" {
  name   = "myapp-sg"
  vpc_id = aws_vpc.new-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name : "${var.env_prefix}-sg"
  }

}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.4.20240513.0-kernel-6.1-x86_64*"]
  }

}

output "aws_ami_id" {
  value = data.aws_ami.latest-amazon-linux-image.id
}

output "ec2_public_ip" {
  value = aws_instance.myproject-server.public_ip
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "server-key"
  public_key = file(var.my_public_key_location)

}

resource "aws_instance" "myproject-server" {
  ami                         = data.aws_ami.latest-amazon-linux-image.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.dev-subnet.id
  vpc_security_group_ids      = [aws_security_group.myproject-sg.id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh-key.key_name
  tags = {
    Name : "${var.env_prefix}-server"
  }

  user_data = file("script.sh")

}



/*resource "aws_instance" "myproject-server" {
  ami = "ami-0ac67a26390dc374d"
}*/



