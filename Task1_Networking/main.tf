provider "aws" {
  region = "ap-south-1"
}

############################
# VPC & Subnets (prefix Sneha_Choudhary_)
############################
resource "aws_vpc" "Sneha_Choudhary_VPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "Sneha_Choudhary_VPC" }
}

resource "aws_subnet" "Sneha_Choudhary_PublicA" {
  vpc_id                  = aws_vpc.Sneha_Choudhary_VPC.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = { Name = "Sneha_Choudhary_PublicA" }
}

resource "aws_subnet" "Sneha_Choudhary_PublicB" {
  vpc_id                  = aws_vpc.Sneha_Choudhary_VPC.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
  tags = { Name = "Sneha_Choudhary_PublicB" }
}

resource "aws_subnet" "Sneha_Choudhary_PrivateA" {
  vpc_id            = aws_vpc.Sneha_Choudhary_VPC.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1a"
  tags = { Name = "Sneha_Choudhary_PrivateA" }
}

resource "aws_subnet" "Sneha_Choudhary_PrivateB" {
  vpc_id            = aws_vpc.Sneha_Choudhary_VPC.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "ap-south-1b"
  tags = { Name = "Sneha_Choudhary_PrivateB" }
}

############################
# Internet Gateway & NAT
############################
resource "aws_internet_gateway" "Sneha_Choudhary_IGW" {
  vpc_id = aws_vpc.Sneha_Choudhary_VPC.id
  tags   = { Name = "Sneha_Choudhary_IGW" }
}

resource "aws_eip" "Sneha_Choudhary_NAT_EIP" {
  vpc = true
  tags = { Name = "Sneha_Choudhary_NAT_EIP" }
}

resource "aws_nat_gateway" "Sneha_Choudhary_NAT" {
  allocation_id = aws_eip.Sneha_Choudhary_NAT_EIP.id
  subnet_id     = aws_subnet.Sneha_Choudhary_PublicA.id
  tags = { Name = "Sneha_Choudhary_NAT" }
  depends_on = [aws_internet_gateway.Sneha_Choudhary_IGW]
}

############################
# Route Tables
############################
resource "aws_route_table" "Sneha_Choudhary_PublicRT" {
  vpc_id = aws_vpc.Sneha_Choudhary_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Sneha_Choudhary_IGW.id
  }
  tags = { Name = "Sneha_Choudhary_PublicRT" }
}

resource "aws_route_table_association" "Sneha_Choudhary_PublicA_Assoc" {
  subnet_id      = aws_subnet.Sneha_Choudhary_PublicA.id
  route_table_id = aws_route_table.Sneha_Choudhary_PublicRT.id
}

resource "aws_route_table_association" "Sneha_Choudhary_PublicB_Assoc" {
  subnet_id      = aws_subnet.Sneha_Choudhary_PublicB.id
  route_table_id = aws_route_table.Sneha_Choudhary_PublicRT.id
}

resource "aws_route_table" "Sneha_Choudhary_PrivateRT" {
  vpc_id = aws_vpc.Sneha_Choudhary_VPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Sneha_Choudhary_NAT.id
  }
  tags = { Name = "Sneha_Choudhary_PrivateRT" }
}

resource "aws_route_table_association" "Sneha_Choudhary_PrivateA_Assoc" {
  subnet_id      = aws_subnet.Sneha_Choudhary_PrivateA.id
  route_table_id = aws_route_table.Sneha_Choudhary_PrivateRT.id
}

resource "aws_route_table_association" "Sneha_Choudhary_PrivateB_Assoc" {
  subnet_id      = aws_subnet.Sneha_Choudhary_PrivateB.id
  route_table_id = aws_route_table.Sneha_Choudhary_PrivateRT.id
}
