#!/bin/bash

# Script: sampleapp-singlevm-setup.sh
# Author: RDudeja
# Copyrights: https://www.svnlabs.com/blogs/install-apache-mysql-php-5-6-on-centos-7/
# Version: 1.0
# Date: 29July2019
# Platform supported: CentOS7 (only)

#Pre-requisites:
# 1. Switch to Root "sudo su -"
# 2. Ensure you also have the additional below scripts located at /root (if not use scp or mobaxterm's file drag-drop to copy)
#  - init.sql
#  - datagen.txt

# 3. Add +x permissions sampleapp-singlevm-setup.sh  script (chmod u+x sampleapp-singlevm-setup.sh)
# 4. Run the script ./sampleapp-singlevm-setup.sh


echo -e "\n ***** 1. Update the yum *****"
yum update -y
if [ $? -eq 0 ]; then echo "Done"; else echo "Fail" && exit -1;fi

echo -e "\n***** 2. Install VIM *****"
yum install vim -y
if [ $? -eq 0 ]; then echo "Done"; else echo "Fail" && exit -1;fi

echo -e "\n***** 3. Install GIT *****"
yum install git -y
if [ $? -eq 0 ]; then echo "Done"; else echo "Fail" && exit -1;fi

echo -e "\n***** 4. Install APACHE *****"

echo -e "\n------ 4.1. Install HTTPD server -----"
yum install httpd -y
if [ $? -eq 0 ]; then echo "Done"; else echo "Fail" && exit -1;fi

echo -e "\n----- 4.2. Start the HTTP service -----"
systemctl start httpd.service
if [ $? -eq 0 ]; then echo "Done"; else echo "Fail" && exit -1;fi

echo -e "\n----- 4.3. Enable Apache to start at server boot -----"
systemctl enable httpd.service
if [ $? -eq 0 ]; then echo "Done"; else echo "Fail" && exit -1;fi


echo -e "\n***** 5. Install MARIADB *****"
yum install mariadb-server mariadb -y
if [ $? -eq 0 ]; then echo "Done"; else echo "Fail" && exit -1;fi


echo -e "\n***** 6. Start MARIADB *****"
systemctl start mariadb
if [ $? -eq 0 ]; then echo "Done"; else echo "Fail" && exit -1;fi

echo -e "\n***** 7. Enable MARIADB to start at boot *****"
systemctl enable mariadb.service
if [ $? -eq 0 ]; then echo "Done"; else echo "Fail" && exit -1;fi


echo -e "\n***** 7. Configure MariaDB for security *****"
echo -e "\n----- IMPORTANT NOTE -----"
echo -e "Press [Enter] when asked, 'Enter current password for root (enter for none)'"
echo -e "Press 'y' to, 'Set root password? [Y/n]'"
echo -e "Set 'root's password to 'root'"
echo -e "Press 'y' when asked, 'Remove anonymous users? [Y/n]'"
echo -e "Press 'y' when asked, 'Disallow root login remotely? [Y/n]'"
echo -e "Press 'y' when asked, 'Remove test database and access to it? [Y/n]'"
echo -e "Press 'y' when asked, 'Reload privilege tables now? [Y/n]'"

mysql_secure_installation
if [ $? -eq 0 ]; then echo "Done"; else echo "Fail" && exit -1;fi

echo -e "\n***** 8. Install PHP56 *****"
echo -e "\n----- 8.1. Install EPEL repository -----"
rpm -Uvh http://vault.centos.org/7.0.1406/extras/x86_64/Packages/epel-release-7-5.noarch.rpm
if [ $? -eq 0 ]; then echo "Done"; else echo "Fail" && exit -1;fi

echo -e "\nNote: Make sure you installed â€œepel-release-7-5.noarch.rpmâ€ else google it for different location â€¦. search on Google â€œindex ofâ€ + epel-release-7-5.noarch.rpm"

echo -e "\n----- 8.2. Install remi repository -----"
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
if [ $? -eq 0 ]; then echo "Done"; else echo "Fail" && exit -1;fi

echo -e "\nNote: Make sure you installed â€œremi-release-7.rpmâ€ else google it for different location"	

echo -e "\n----- 8.3. Enable remi -----"
yum --enablerepo=remi,remi-php56 install php php-common -y
if [ $? -eq 0 ]; then echo "Done"; else echo "Fail" && exit -1;fi

echo -e "\n----- 8.4. Install php 5.6 on Centos 7 -----"
yum --enablerepo=remi,remi-php56 install php-cli php-pear php-pdo php-mysql php-mysqlnd php-pgsql php-sqlite php-gd php-mbstring php-mcrypt php-xml php-simplexml php-curl php-zip -y
if [ $? -eq 0 ]; then echo "Done"; else echo "Fail" && exit -1;fi


echo -e "\n----- 8.5. Restart HTTPD service -----"
systemctl restart httpd.service
if [ $? -eq 0 ]; then echo "Done"; else echo "Fail" && exit -1;fi


echo -e "\n***** 9. GIT Clone the SampleApp repo *****"
cd /var/www/html
git clone "https://github.com/taniarascia/pdo.git"
if [ $? -eq 0 ]; then echo "Done"; else echo "Fail" && exit -1;fi

echo -e "\n***** 10. Rename PDO to SampleApp and Copy to /var/www/html *****"
mv pdo SampleApp
#mv SampleApp /var/www/html/SampleApp
#mv /root/init.sql /var/www/html/SampleApp/data/init.sql


echo -e "\n***** 11. Test Setup *****"
echo -e "Open http://<publicIp of webservre>/SampleApp/public/index.php"


