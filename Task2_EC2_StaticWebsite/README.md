# Task 2 – EC2 Static Resume Website Hosting

## Brief Explanation
I launched a free-tier EC2 instance named Sneha_Choudhary_EC2 in a public subnet and attached a security group allowing HTTP (port 80) and SSH (port 22). 
Nginx was installed using a user_data script, and the default page was replaced with my resume content. 
The instance was assigned a public IP so the website could be accessed over the internet. 
Basic hardening steps were applied by allowing only required inbound ports and enabling automatic package updates in the user-data script.

## Screenshots
- EC2_Instance.png  
- Security_Group.png  
- Website.png  

## Terraform Code
See `main.tf` and `user_data.sh`.
