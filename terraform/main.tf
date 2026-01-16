provider "aws" {
  region = "ap-southeast-1"
}

# 1. VPC
resource "aws_vpc" "devops_vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
  tags = { Name = "devops-vpc" }
}

# 2. Subnets
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.devops_vpc.id
  cidr_block        = "10.0.0.0/25"
  availability_zone = "ap-southeast-1a"
  tags = { Name = "devops-public-subnet" }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.devops_vpc.id
  cidr_block        = "10.0.0.128/25"
  availability_zone = "ap-southeast-1a"
  tags = { Name = "devops-private-subnet" }
}

# 3. Gateways
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.devops_vpc.id
  tags   = { Name = "devops-igw" }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags          = { Name = "devops-ngw" }
}

# 4. Route Tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.devops_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "devops-public-route" }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.devops_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  tags = { Name = "devops-private-route" }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}