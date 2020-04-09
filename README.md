# Yiimp_install_scrypt (update Avril, 2020)

Site : https://www.xavatar.com

Discord : https://discord.gg/zcCXjkQ

TUTO Youtube (16.04 - Without SSL) : https://www.youtube.com/watch?v=vdBCw6_cyig

TUTO Youtube (16.04 - With SSL) : https://www.youtube.com/watch?v=fWwGow_i-Vw

Official Yiimp (used in this script for Yiimp Installation): https://github.com/tpruvot/yiimp

Install script for yiimp on Ubuntu 17.10 : https://github.com/xavatar/yiimp_install_scrypt_ubuntu17.10

Install script for yiimp on Ubuntu 18.04 : https://github.com/xavatar/yiimp_install_scrypt_ubuntu18.04


***********************************

## Install script for yiimp on Ubuntu Server 16.04

USE THIS SCRIPT ON FRESH INSTALL UBUNTU Server 16.04 !

Connect on your VPS =>
- adduser pool
- adduser pool sudo
- su - pool
- sudo apt-get -y install git
- git clone https://github.com/xavatar/yiimp_install_scrypt.git
- cd yiimp_install_scrypt/
- sudo bash install.sh (Do not run the script as root)
- sudo bash screen-scrypt.sh (in tuto youtube, i launch the script with root... it does not matter)
- NOT MANDATORY => sudo bash screen-stratum.sh (CONFIGURE BEFORE START this script... add or remove algo you use).

Finish !
Go http://xxx.xxxxxx.xxx or https://xxx.xxxxxx.xxx (if you have chosen LetsEncrypt SSL). Enjoy !

###### :bangbang: **YOU MUST UPDATE THE FOLLOWING FILES :**
- **/var/web/serverconfig.php :** update this file to include your public ip (line = YAAMP_ADMIN_IP) to access the admin panel (Put your PERSONNAL IP, NOT IP of your VPS). update with public keys from exchanges. update with other information specific to your server..
- **/etc/yiimp/keys.php :** update with secrect keys from the exchanges (not mandatory)


###### :bangbang: **IMPORTANT** : 

- The configuration of yiimp and coin require a minimum of knowledge in linux
- Your mysql information (login/Password) is saved in **~/.my.cnf**
- **If you reboot your VPS**, you must restart screen-scrypt.sh (or add crontab)
- Remember to restart **memcached service** after the db change (update or import new .sql)

***********************************

###### This script has an interactive beginning and will ask for the following information :

- Enter time zone
- Server Name 
- Are you using a subdomain
- Enter support email
- Set stratum to AutoExchange
- New location for /site/adminRights
- Your Public IP for admin access (Put your PERSONNAL IP, NOT IP of your VPS)
- Install Fail2ban
- Install UFW and configure ports
- Install LetsEncrypt SSL

***********************************

**This install script will get you 95% ready to go with yiimp. There are a few things you need to do after the main install is finished.**

While I did add some server security to the script, it is every server owners responsibility to fully secure their own servers. After the installation you will still need to customize your serverconfig.php file to your liking, add your API keys, and build/add your coins to the control panel. 

There will be several wallets already in yiimp. These have nothing to do with the installation script and are from the database import from the yiimp github. 

If you need further assistance we have a small but growing discord channel at https://discord.gg/zcCXjkQ

If this helped you or you feel giving please donate : 
- BTC Donation : 1C1hnjk3WhuAvUN6Ny6LTxPD3rwSZwapW7
- BCH Donation : 1PqjApUdjwU9k4v1RDWf6XveARyEXaiGUz
- ETH Donation : 0xc23E6902fF8Cd8878EDADE18Dc49B3505395F0a1
