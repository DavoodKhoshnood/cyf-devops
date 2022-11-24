#!/bin/bash
sudo apt update -y
sudo apt install npm -y
sudo apt install git -y
sudo apt install nodejs -y
sudo apt install nginx -y
sudo npm install pm2 -g -y

cd /home/ubuntu
git clone https://github.com/DavoodKhoshnood/cyf-first-api.git


sudo unlink /etc/nginx/sites-enabled/default
sudo unlink /etc/nginx/sites-available/default
cd /etc/nginx/sites-available
cat <<NGINXCONFIG >> myserver.config
server{
    listen 80;
    server_name wach.quest;
    location / {
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Host \$host;
        proxy_pass http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        # location /overview {
        #     proxy_pass http://127.0.0.1:3000\$request_uri;
        #     proxy_redirect off;
        # }
    }
}
NGINXCONFIG

sudo ln -s /etc/nginx/sites-available/myserver.config /etc/nginx/sites-enabled/
sudo systemctl restart nginx

cd /home/ubuntu/cyf-first-api
sudo pm2 stop index.js
sudo pm2 start index.js
