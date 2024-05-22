#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
myip='curl checkip.amazonaws.com'
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www
find /var/www -type f -exec sudo chmod 0664 {} \;
sudo echo "<h2>WebServer with IP: $myip</h2> Made with Terraform" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
