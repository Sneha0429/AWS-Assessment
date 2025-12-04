provider "aws" {
  region = "ap-south-1"
}

# ------------------------
# EC2 Security Group
# ------------------------
resource "aws_security_group" "Sneha_Choudhary_EC2_SG" {
  name        = "Sneha_Choudhary_EC2_SG"
  description = "Allow HTTP traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "Sneha_Choudhary_EC2_SG" }
}

# ------------------------
# EC2 Instance
# ------------------------
resource "aws_instance" "Sneha_Choudhary_EC2" {
  ami           = "ami-0f5ee92e2d63afc18"  # Amazon Linux 2 (Free Tier)
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.Sneha_Choudhary_EC2_SG.id]
  associate_public_ip_address = true

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "Sneha_Choudhary_EC2"
  }
}

# ------------------------
# Variables
# ------------------------
variable "vpc_id" {}
variable "public_subnet_id" {}
