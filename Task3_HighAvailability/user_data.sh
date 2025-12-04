#!/bin/bash
# user-data for ASG instances: install nginx and serve a simple page
apt-get update -y
apt-get install -y nginx
systemctl enable nginx
cat > /var/www/html/index.html <<'EOF'
<!doctype html>
<html>
  <head><meta charset="utf-8"><title>ASG App - Sneha Choudhary</title></head>
  <body>
    <h1>ASG Instance</h1>
    <p>Hosted by Sneha_Choudhary_ASG instance.</p>
  </body>
</html>
EOF
chown -R www-data:www-data /var/www/html
systemctl restart nginx
