provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "Sneha_VPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "Sneha_VPC" }
}

resource "aws_subnet" "Sneha_PublicA" {
  vpc_id                  = aws_vpc.Sneha_VPC.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = { Name = "Sneha_PublicA" }
}

resource "aws_subnet" "Sneha_PublicB" {
  vpc_id                  = aws_vpc.Sneha_VPC.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = { Name = "Sneha_PublicB" }
}

resource "aws_subnet" "Sneha_PrivateA" {
  vpc_id            = aws_vpc.Sneha_VPC.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1a"
  tags = { Name = "Sneha_PrivateA" }
}

resource "aws_subnet" "Sneha_PrivateB" {
  vpc_id            = aws_vpc.Sneha_VPC.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-south-1b"
  tags = { Name = "Sneha_PrivateB" }
}

resource "aws_internet_gateway" "Sneha_IGW" {
  vpc_id = aws_vpc.Sneha_VPC.id
  tags   = { Name = "Sneha_IGW" }
}

resource "aws_eip" "Sneha_NAT_EIP" {
  vpc   = true
  tags  = { Name = "Sneha_NAT_EIP" }
}

resource "aws_nat_gateway" "Sneha_NAT" {
  allocation_id = aws_eip.Sneha_NAT_EIP.id
  subnet_id     = aws_subnet.Sneha_PublicA.id
  tags          = { Name = "Sneha_NAT" }
}

resource "aws_route_table" "Sneha_PublicRT" {
  vpc_id = aws_vpc.Sneha_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Sneha_IGW.id
  }
  tags = { Name = "Sneha_PublicRT" }
}

resource "aws_route_table_association" "Sneha_PublicA_Assoc" {
  subnet_id      = aws_subnet.Sneha_PublicA.id
  route_table_id = aws_route_table.Sneha_PublicRT.id
}

resource "aws_route_table_association" "Sneha_PublicB_Assoc" {
  subnet_id      = aws_subnet.Sneha_PublicB.id
  route_table_id = aws_route_table.Sneha_PublicRT.id
}

resource "aws_route_table" "Sneha_PrivateRT" {
  vpc_id = aws_vpc.Sneha_VPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Sneha_NAT.id
  }
  tags = { Name = "Sneha_PrivateRT" }
}

resource "aws_route_table_association" "Sneha_PrivateA_Assoc" {
  subnet_id      = aws_subnet.Sneha_PrivateA.id
  route_table_id = aws_route_table.Sneha_PrivateRT.id
}

resource "aws_route_table_association" "Sneha_PrivateB_Assoc" {
  subnet_id      = aws_subnet.Sneha_PrivateB.id
  route_table_id = aws_route_table.Sneha_PrivateRT.id
}
