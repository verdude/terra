variable "az" {
  description = "availability zone for the subnet"
  type = string

  default = "us-east-1a"
}

variable "az2" {
  description = "availability zone for the subnet"
  type = string

  default = "us-east-1b"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Main VPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.az

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "public2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = var.az2

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main Internet Gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Custom Main Route Table With IGW Access"
  }
}

resource "aws_main_route_table_association" "main_route_assoc" {
  vpc_id = aws_vpc.main.id
  route_table_id = aws_route_table.public.id
}

output "igw" {
  value = aws_internet_gateway.igw
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "p_subnet_id" {
  value = aws_subnet.public.id
}

output "p2_subnet_id" {
  value = aws_subnet.public2.id
}
