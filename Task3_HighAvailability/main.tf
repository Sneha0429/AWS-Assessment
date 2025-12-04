terraform {
  required_providers { aws = { source = "hashicorp/aws" } }
  required_version = ">= 1.4"
}

provider "aws" { region = "ap-south-1" }

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

variable "vpc_id" {}
variable "public_subnet_ids" { type = list(string) }   # 2 public subnet IDs
variable "private_subnet_ids" { type = list(string) }  # 2 private subnet IDs
variable "key_name" { default = "" }

# ALB SG
resource "aws_security_group" "Sneha_Choudhary_ALB_SG" {
  name   = "Sneha_Choudhary_ALB_SG"
  vpc_id = var.vpc_id
  description = "Allow HTTP from anywhere to ALB"
  ingress { from_port = 80; to_port = 80; protocol = "tcp"; cidr_blocks = ["0.0.0.0/0"] }
  egress  { from_port = 0; to_port = 0; protocol = "-1"; cidr_blocks = ["0.0.0.0/0"] }
  tags = { Name = "Sneha_Choudhary_ALB_SG" }
}

# App SG - only ALB can talk to instances on 80
resource "aws_security_group" "Sneha_Choudhary_App_SG" {
  name   = "Sneha_Choudhary_App_SG"
  vpc_id = var.vpc_id
  description = "Allow HTTP from ALB only"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.Sneha_Choudhary_ALB_SG.id]
  }
  # No SSH open; use SSM
  egress { from_port = 0; to_port = 0; protocol = "-1"; cidr_blocks = ["0.0.0.0/0"] }
  tags = { Name = "Sneha_Choudhary_App_SG" }
}

# ALB (internet-facing)
resource "aws_lb" "Sneha_Choudhary_ALB" {
  name               = "Sneha_Choudhary_ALB"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.Sneha_Choudhary_ALB_SG.id]
  tags = { Name = "Sneha_Choudhary_ALB" }
}

# Target group
resource "aws_lb_target_group" "Sneha_Choudhary_TG" {
  name     = "Sneha_Choudhary_TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path = "/"
    matcher = "200-399"
    interval = 30
    timeout  = 5
    healthy_threshold = 2
    unhealthy_threshold = 3
  }
  tags = { Name = "Sneha_Choudhary_TG" }
}

# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.Sneha_Choudhary_ALB.arn
  port              = "80"
  protocol          = "HTTP"
  default_action { type = "forward"; target_group_arn = aws_lb_target_group.Sneha_Choudhary_TG.arn }
}

# IAM role for EC2 (SSM)
data "aws_iam_policy_document" "ec2_assume_role" {
  statement { actions = ["sts:AssumeRole"]; principals { type = "Service"; identifiers = ["ec2.amazonaws.com"] } }
}
resource "aws_iam_role" "Sneha_Choudhary_EC2_Role" {
  name = "Sneha_Choudhary_EC2_Role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}
resource "aws_iam_role_policy_attachment" "attach_ssm" {
  role       = aws_iam_role.Sneha_Choudhary_EC2_Role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_instance_profile" "Sneha_Choudhary_InstanceProfile" {
  name = "Sneha_Choudhary_InstanceProfile"
  role = aws_iam_role.Sneha_Choudhary_EC2_Role.name
}

# Launch Template
resource "aws_launch_template" "Sneha_Choudhary_LT" {
  name_prefix   = "Sneha_Choudhary_LT-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = var.key_name != "" ? var.key_name : null

  iam_instance_profile { name = aws_iam_instance_profile.Sneha_Choudhary_InstanceProfile.name }

  network_interfaces {
    security_groups = [aws_security_group.Sneha_Choudhary_App_SG.id]
    associate_public_ip_address = false
  }

  user_data = file("${path.module}/user_data.sh")

  tag_specifications {
    resource_type = "instance"
    tags = { Name = "Sneha_Choudhary_ASG_Instance" }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "Sneha_Choudhary_ASG" {
  name                = "Sneha_Choudhary_ASG"
  max_size            = 3
  min_size            = 1
  desired_capacity    = 1
  vpc_zone_identifier = var.private_subnet_ids
  launch_template {
    id      = aws_launch_template.Sneha_Choudhary_LT.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.Sneha_Choudhary_TG.arn]
  health_check_type = "ELB"
  health_check_grace_period = 30

  tag {
    key                 = "Name"
    value               = "Sneha_Choudhary_ASG_Instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "alb_dns" { value = aws_lb.Sneha_Choudhary_ALB.dns_name }
output "asg_name" { value = aws_autoscaling_group.Sneha_Choudhary_ASG.name }
output "target_group_arn" { value = aws_lb_target_group.Sneha_Choudhary_TG.arn }
