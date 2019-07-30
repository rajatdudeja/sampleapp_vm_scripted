# sampleapp_vm_scripted
A 2-tier sample application deployed in VM / Physical env. Contains scripts to setup Web and DB server on the same VM
Contains the below files:
1. datagen.txt - file containing 1000 records that we can load in the database
2. sampleapp-singlevm-setup.sh - running this script installs pre-requisites for Apache and MySQL server then configure both the servers
3. SampleApp/ folder containing the App

Steps to hosting the SampleApp on AWS EC2
******************************************
1. Provision a CentOS7 VM (use official AMI ami-02e60be79e78fef21 or any new one)

2. While provisioning, add the below UserData (the cloud-config script, which will run only at instance launch time)
>>>>COPY BELOW LINE >>>>
#cloud-config

runcmd:
 - sudo yum install -y git
 - sudo git clone https://rajatdudeja:<password>#@github.com/rajatdudeja/sampleapp_vm_scripted.git /root/sampleapp_vm_scripted

>>> Copy till above line only >>>

Note: 
  a. replace the <password> with the password of the repo
  b. tested on the instance provisioned in public subnet that provided a public ip to the server

3. Once launched and if status passed ok (on AWS), login into the server with the user 'centos'
4. change to root user (sudo su -) (as all commands require root privileges)
5. You will see a folder: /root/sampleapp_vm_scripted
6. change to /root/sampleapp_vm_scripted and run the script 'sampleapp-singlevm-setup.sh'
./sampleapp-singlevm-setup.sh

This will install HTTPD, MARIADB, PHP56, VIM and dependent packages. 

7. Post successful execution of the script, edit '/etc/httpd/conf/httpd.conf' and replace the below code section as:

Original Code:
<IfModule dir_module>
    DirectoryIndex index.html
</IfModule>

Replace with:
<IfModule dir_module>
    DirectoryIndex index.php index.html
</IfModule>

Now restart the httpd service, 'service httpd restart'

8. Post successful execution of the script, open a browser and run http://<public-ip-server>/SampleApp
  
Note: add the public ip in the URL

9. This will display a host of files, click on install.php (which will create the database)

10. Now change the URL to http://<public-ip-instance>/SampleApp/index.php
  
Complete !!
