provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "my-tf-state-url-shortener"
    key = "VPC/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "url-shortener-vpc"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
      Name = "public-subnet-2"
    }
}

resource "aws_internet_gateway" "main_gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public-gateway"
  }
}

resource "aws_route_table" "main_route" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gateway.id
  }
}
resource "aws_route_table_association" "a1" {
    subnet_id = aws_subnet.public_1.id
    route_table_id = aws_route_table.main_route.id
}

resource "aws_route_table_association" "a2" {
    subnet_id = aws_subnet.public_2.id
    route_table_id = aws_route_table.main_route.id
}