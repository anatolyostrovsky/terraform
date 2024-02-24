provider "aws" {}

resource "aws_instance" "my-ubuntu" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"

  tags = {
    Name    = "My Ubuntu Server"
    Owner   = "Anatoly Ostrovsky"
    Project = "Terraform Lessons"
  }

}

resource "aws_instance" "my-amazon-linux" {
  ami           = "ami-0440d3b780d96b29d"
  instance_type = "t2.micro"

  tags = {
    Name    = "My Amazon Server"
    Owner   = "Anatoly Ostrovsky"
    Project = "Terraform Lessons"
  }


}
