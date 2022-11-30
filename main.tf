terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.41.0"
      
    }
  }
}
provider "aws" {
  # Configuration options
  region = "us-east-1"
  # access_key = "AKIATIRSMLQF5VKF7XWB"
  # secret_key = "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"
  
}
#creating vpc
resource "aws_vpc" "ujas-vpc" {
  cidr_block = var.cidr_block[0]
  tags= {
    Name = "ujas-vpc"
  }
}

#SUBNET
resource "aws_subnet" "ujas-subnet" {
  vpc_id     = aws_vpc.ujas-vpc.id
  cidr_block = var.cidr_block[0]

  tags = {
    Name = "ujas-subnet"
  }
}
#provisioning of EC2
resource "aws_instance" "My-apache-site" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name = "first-class"
  subnet_id = aws_subnet.ujas-subnet.id
  vpc_security_group_ids = [aws_security_group.Helloworld-sg.id]
  associate_public_ip_address = true
  user_data = file ("./mysite.sh")
  tags = {
    Name = "Mysite"
  }
}


#security group
resource "aws_security_group" "Helloworld-sg" {
  name        = "allow_tls"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.ujas-vpc.id

  dynamic ingress {
    # description      = "Allow SSH from VPC"
    iterator = port
    for_each = var.ports
    content{
      from_port =port.value
      to_port = port.value
      cidr_blocks      = ["0.0.0.0/0"]
      protocol         = "tcp"
         }
    # from_port        = 22
    # to_port          = 22
     
  
    # cidr_blocks      = [aws_vpc.main.cidr_block]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  # ingress {
  #   description      = "Allow port 80 from VPC"
  #   from_port        = 80
  #   to_port          = 80
  #   protocol         = "tcp"
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   # cidr_blocks      = [aws_vpc.main.cidr_block]
  #   # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  # }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
