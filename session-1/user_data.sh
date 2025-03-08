#!/bin/bash
sudo apt update

#Install Java and Compiler
sudo apt-get install default-jre -y
sudo apt-get install default-jdk -y 

#Download Jenkins Key and add repository to install
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y

#Start and Enable
sudo systemctl start jenkins
sudo systemctl enable jenkins

#Change hostname to jenkins
sudo hostnamectl set-hostname jenkins

#Install and Configure nginx proxy
sudo apt-get update && sudo apt-get install nginx -y
sudo tee /etc/nginx/sites-available/jenkins <<-EOF
server {
    listen 80;
    server_name jenkins.tesraa.com www.jenkins.tesraa.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header   Host              \$http_host;
        proxy_set_header   X-Real-IP         \$remote_addr;
        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto \$scheme;
    }
}
EOF

#create symbolic link
sudo ln -s /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/

#Test and reload (check for syntax errors)
sudo nginx -t
sudo systemctl reload nginx

#INSTALL CERTBOT
sudo apt-get install certbot python3-certbot-nginx -y
sleep 60 
certbot --nginx \
    --non-interactive \
    --agree-tos \
    --email miigook@github.com \
    --redirect \
    -d jenkins.tesraa.com \
    -d www.jenkins.tesraa.com

sudo systemctl reload nginx