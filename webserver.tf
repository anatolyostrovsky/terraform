#-------------------------------------------------------------------------------------
#
# Terraform
#
# WebServer with Bootstrap
#
# Created by Anatolijs Ostrovskis
#
#-------------------------------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.4.20240513.0-kernel-6.1-x86_64*"]
  }
}

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.latest-amazon-linux-image.id # Latest Amazon Linux AMI
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.new_server_sg.id]
  user_data              = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip='curl http://169.254.169.254/latest/meta-data/local-ipv4'
echo "<h2>WebServer with IP: $myip</h2>" > Made with Terraform" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
EOF
}

resource "aws_security_group" "new_server_sg" {
  name        = "web_server_sg"
  description = "web Server Security Group"

}

resource "aws_vpc_security_group_ingress_rule" "allow_all_80_ipv4" {
  security_group_id = aws_security_group.new_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_443_ipv4" {
  security_group_id = aws_security_group.new_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.new_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

