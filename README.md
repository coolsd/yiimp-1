# yiimp
Install script for yiimp on Ubuntu 16.04

Before running this script make sure you are on a fresh server and running as a user. Do not run this script under root!

This script has an interactive begining and will ask for the following information:
1. Your time zone
2. Server Name - IMPORTANT - You must already have your domain name pointed to your server before running the script or else the SSL install will fail!
3. Server IP for hosts file update
4. Support Email Address 
5. Server Admin Email Address 
6. If you would like fail2ban installed
7. Send test email from server

Once those questions are answered the script will then be fully automated for the rest of the install. 

1. The script will update your hosts file with server ip and server name.
2. Disable and remove AppAromor
3. Update and Upgrade Ubuntu Packages
4. Install Aptitude
5. Install and configure Nginx
6. Install MariaDB with random root password
7. Install php7
8. Install various dev packages required for building blocknotify and stratum
9. Install SendMail
10. Install Fail2Ban if selected
11. Install and configur phpmyadmin with random password for phpmyadmin user
13. Clone yiimp build packages, create directory structure, set file permissions, and more
14. Update server clock
15. Install LetsEncrypt
16. Create yiimp database, create 2 users with random passwords - passwords saved in ~/.my.cnf
17. Import the sql dumps from yiimp
18. Create base yiimp serverconfig.php file to get you going
19. Updates all directory permissions

This install script will get you 95% ready to go with yiimp. There are a few things you need to do after the main install is finished.

You must update the following files:

1. /var/web/serverconfig.php - update this file to include your public ip to access the admin panel. update with public keys from exchanges. update with other information specific to your server..
2. /etc/yiimp/keys.php - update with secrect keys from the exchanges. 

After you add the missing information to those files then run:
./main.sh
./loop2.sh
./block.sh

To download and run 

curl -Lo install.sh https://raw.githubusercontent.com/crombiecrunch/yiimp/master/install.sh 

bash install.sh


If this helped you or you feel giving please donate BTC Donation: 1AxK9a7dgeHvf3VFuwZ2adGiQTX6S1nhrp

Crombie Crunch
