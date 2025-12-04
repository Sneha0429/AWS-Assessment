#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install nginx1 -y
sudo systemctl enable nginx
sudo systemctl start nginx

# Replace default page with resume
echo "<h1>Resume - Sneha Choudhary</h1><p>This is my static resume website hosted on Nginx.</p>" | sudo tee /usr/share/nginx/html/index.html
