#!/bin/bash

# Install SSM Agent
apt install -y amazon-ssm-agent
systemctl start amazon-ssm-agent
systemctl enable amazon-ssm-agent

# Install and start NGINX
apt install -y nginx
systemctl start nginx
systemctl enable nginx

# Create a simple index.html file
echo "<!DOCTYPE html>
<html>
<head>
    <title>Welcome to My DevOps Training World</title>
</head>
<body>
    <h1>Disclaimer! If you trespass, you goin learn the hard way.</h1>
</body>
</html>" > /var/www/html/index.nginx-debian.html

# Restart NGINX to load the new index.html
systemctl restart nginx
