# Task 3 – High Availability & Auto Scaling

## Brief Explanation
I deployed an internet-facing ALB (Sneha_Choudhary_ALB) in public subnets which forwards traffic to a target group.  
EC2 instances are launched by an Auto Scaling Group (Sneha_Choudhary_ASG) across two private subnets for fault tolerance.  
A Launch Template installs Nginx via user-data to serve a simple page.  
The ALB receives public traffic and routes it to private EC2 instances, ensuring the flow: public → ALB → private EC2.

## Screenshots (place in screenshots/)
- ALB_Config.png
- TargetGroup.png
- ASG.png
- ASG_EC2s.png

## Terraform
See `main.tf`. Pass vpc_id, public_subnet_ids (list), private_subnet_ids (list), and optional key_name.

