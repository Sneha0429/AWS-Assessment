# Task 1 – AWS Networking & Subnetting (VPC Setup)

## Brief Explanation
I created a VPC named Sneha_Choudhary_VPC using CIDR 10.0.0.0/16, allowing space for multiple subnets. 
Two public subnets (10.0.1.0/24 and 10.0.2.0/24) were deployed across different AZs for internet-facing components and the NAT Gateway. 
Two private subnets (10.0.3.0/24 and 10.0.4.0/24) were created for backend workloads. 
An Internet Gateway enables public subnet connectivity, while a NAT Gateway in a public subnet provides secure outbound access for private subnets. 
Separate route tables ensure proper routing and network isolation.

## CIDR Ranges
- VPC: 10.0.0.0/16  
- Public Subnet A: 10.0.1.0/24  
- Public Subnet B: 10.0.2.0/24  
- Private Subnet A: 10.0.3.0/24  
- Private Subnet B: 10.0.4.0/24  

## Why These CIDRs?
A /16 VPC provides flexibility for growth.  
Each /24 subnet gives 251 usable IPs and keeps allocation simple and consistent across AZs.

## Screenshots
(Located in the screenshot folder)
- VPC.png  
- Subnets.png  
- RouteTables.png  
- NAT_IGW.png  

## Terraform File
See `main.tf`
