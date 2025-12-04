# Task 1 — AWS Networking & Subnetting (VPC Setup)

## 1. Brief Explanation
I created a custom VPC (Sneha_VPC) using CIDR 10.0.0.0/16 to allow future subnet expansion. 
Two public subnets (10.0.1.0/24, 10.0.2.0/24) were created across different AZs for internet-facing resources. 
Two private subnets (10.0.3.0/24, 10.0.4.0/24) were created for backend components. 
An Internet Gateway enables outbound/inbound connectivity for public subnets. 
A NAT Gateway in the public subnet allows private subnets to access external resources securely. 
Public and private route tables were configured for proper routing.

## 2. CIDR Ranges Used

| Component           | CIDR Block     |
|--------------------|----------------|
| VPC                | 10.0.0.0/16    |
| Public Subnet A    | 10.0.1.0/24    |
| Public Subnet B    | 10.0.2.0/24    |
| Private Subnet A   | 10.0.3.0/24    |
| Private Subnet B   | 10.0.4.0/24    |

## 3. Screenshots
(Add these inside screenshots/)
- vpc.png
- subnets.png
- route_tables.png
- nat_igw.png

## 4. Terraform Code
See **main.tf**
