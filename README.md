# yiimp


Discord : https://discord.gg/zcCXjkQ

TUTO Youtube : https://www.youtube.com/watch?v=vdBCw6_cyig


***********************************


Install script for yiimp on Ubuntu 16.04


Connect on your VPS =>

adduser pool

adduser pool sudo

su - pool

git clone https://github.com/xavatar/yiimp_install_scrypt.git

cd yiimp_install_scrypt/

***** Do not run the script as root *****

sudo bash install.sh

sudo bash screen-scrypt.sh



Finish !
Go http://xxx.xxxxxx.xxx and Enjoy !


You must update the following files:

1. /var/web/serverconfig.php - update this file to include your public ip to access the admin panel. update with public keys from exchanges. update with other information specific to your server..
2. /etc/yiimp/keys.php - update with secrect keys from the exchanges. 

***********************************

This script has an interactive beginning and will ask for the following information :

Enter time zone

Server Name 

Are you using a subdomain

Enter support email

Set stratum to AutoExchange

New location for /site/adminRights

Your Public IP for admin access

Install Fail2ban

Install UFW and configure ports

Install LetsEncrypt SSL


***********************************


While I did add some server security to the script, it is every server owners responsibility to fully secure their own servers. After the installation you will still need to customize your serverconfig.php file to your liking, add your API keys, and build/add your coins to the control panel. 

There will be several wallets already in yiimp. These have nothing to do with the installation script and are from the database import from the yiimp github. 

If you need further assistance we have a small but growing discord channel at https://discord.gg/zcCXjkQ

This install script will get you 95% ready to go with yiimp. There are a few things you need to do after the main install is finished.



If this helped you or you feel giving please donate BTC Donation: 1PqjApUdjwU9k4v1RDWf6XveARyEXaiGUz


