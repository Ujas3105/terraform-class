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
  region = "us-east-2"
  # access_key = "AKIATIRSMLQF5VKF7XWB"
  # secret_key = "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"
  
}
# #creating vpc
# resource "aws_vpc" "ujas-vpc" {
#   cidr_block = var.cidr_block[0]
#   tags= {
#     Name = "ujas-vpc"
#   }
# }
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

#SUBNET
# 
resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-2a"

  tags = {
    Name = "Default subnet for us-east-2"
  }
}
#provisioning of EC2
resource "aws_instance" "My-site" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name = "ujas-key"
  subnet_id = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.ujas-sg.id]
  associate_public_ip_address = true
  # user_data = file ("./mysite.sh")
  user_data = "${file("mysite.sh")}"
  tags = {
    Name = "My-site"
  }
}


#security group
resource "aws_security_group" "ujas-sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  dynamic ingress {
    # description      = "Allow SSH from VPC"
    iterator = port
    for_each = var.ports
    content{
      from_port = port.value
      to_port = port.value
       protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
   
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
    Name = "allow_ssh and http"
  }
}
# # internet gateway
# resource "aws_internet_gateway" "ujas-GW"{
#   vpc_id = aws_vpc.ujas-vpc.id

#   tags = {
#     Name = "ujas_internetGW"
#   }
# }
# # route table

# resource "aws_route_table" "ujas-routetable"{
#   vpc_id = aws_vpc.ujas-vpc.id
#   route{
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.ujas-GW.id
#   }
# tags = {
#       Name: "ujas_route_table"
#     }
# }
# #route table association

# resource "aws_route_table_association" "route_table_assoc"{
#   subnet_id = aws_subnet.ujas-subnet.id
#   route_table_id = aws_route_table.ujas-routetable.id
# }