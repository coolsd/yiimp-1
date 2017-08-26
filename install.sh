#!/bin/bash
################################################################################
# Author:   crombiecrunch
# 
# Web:      www.thecryptopool.com
#
# Program:
#   Install yiimp on Ubuntu 16.04 running Nginx, MariaDB, and php7.x
# BTC Donation: 
################################################################################
output() {
    printf "\E[0;33;40m"
    echo $1
    printf "\E[0m"
}

displayErr() {
    echo
    echo $1;
    echo
    exit 1;
}
clear
    read -p "Enter admin email (e.g. admin@example.com) : " EMAIL
    read -p "Enter servername (e.g. portal.example.com) : " SERVNAME
    read -p "Enter time zone (e.g. America/New_York) : " TIME
    
    output "If you found this helpful, please donate!"
    output "Updating system and installing required packages."

    #Disable AppArmor
    sudo service apparmor stop
    sudo update-rc.d -f apparmor remove
    sudo apt-get -y remove apparmor apparmor-utils
    
    # update package and upgrade Ubuntu
    sudo apt-get -y update 
    sudo apt-get -y upgrade
    sudo apt-get -y autoremove
    clear
    output "Switching to Aptitude"
    sudo apt-get -y install aptitude
    
    output "Installing Nginx server."
    sudo aptitude -y install nginx
    sudo service nginx start
    sudo service cron start
    
    output "Installing Mariadb Server."
    # create random password
    rootpasswd=$(openssl rand -base64 12)
    export DEBIAN_FRONTEND="noninteractive"
    sudo aptitude -y install mariadb-server
    
    output "Installing php7.x and other needed files"
    sudo aptitude -y install php7.0-fpm
    sudo aptitude -y install php7.0-opcache php7.0-fpm php7.0 php7.0-common php7.0-gd php7.0-mysql php7.0-imap php7.0-cli php7.0-cgi php-pear php-auth php7.0-mcrypt mcrypt imagemagick libruby php7.0-curl php7.0-intl php7.0-pspell php7.0-recode php7.0-sqlite3 php7.0-tidy php7.0-xmlrpc php7.0-xsl memcached php-memcache php-imagick php-gettext php7.0-zip php7.0-mbstring
    sudo phpenmod mcrypt
    sudo phpenmod mbstring
    sudo aptitude -y install libgmp3-dev
    sudo aptitude -y install libmysqlclient-dev
    sudo aptitude -y install libcurl4-gnutls-dev
    sudo aptitude -y install libkrb5-dev
    sudo aptitude -y install libldap2-dev
    sudo aptitude -y install libidn11-dev
    sudo aptitude -y install gnutls-dev
    sudo aptitude -y install librtmp-dev
    sudo aptitude -y install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils
    clear
    output "Grabbing yiimp fron Github, building files and setting file structure."
    cd ~
    git clone https://github.com/tpruvot/yiimp.git
    cd yiimp
    cd blocknotify
    sudo make
    cd ~/yiimp/stratum/iniparser
    sudo make
    cd ..
    sudo make
    cd ..
    sudo cp -r web /var/
    sudo cp -r stratum /var/stratum
    sudo cp -a bin/. /bin/
    sudo cp -r blocknotify/blocknotify /var/stratum
    
    output "Update default timezone."
    output "Thanks for using this installation script. Donations welcome"
    # check if link file
    sudo [ -L /etc/localtime ] &&  sudo unlink /etc/localtime
    # update time zone
    sudo ln -sf /usr/share/zoneinfo/$TIME /etc/localtime
    sudo aptitude -y install ntpdate
    # write time to clock.
    sudo hwclock -w
    clear
    output "Making Web Server Magic Happen!"
    # adding user to group, creating dir structure, setting permissions
    whoami=`whoami`
    sudo mkdir -p /var/www/$SERVNAME/html
    sudo chown -R $whoami:$whoami /var/www/$SERVNAME/html
    sudo chmod -R 775 /var/www/$SERVNAME/html
    
    output "Creating webserver initial config file"
echo '
    server {
        listen 80;
        listen [::]:80;
        server_name '"${SERVNAME}"';
    
        root "/var/www/'"${SERVNAME}"'/html/web";
        index index.html index.htm index.php;
        charset utf-8;
    
        location / {
        try_files $uri $uri/ /index.php?$args;
        }
        location @rewrite {
        rewrite ^/(.*)$ /index.php?r=$1;
        }
    
        location = /favicon.ico { access_log off; log_not_found off; }
        location = /robots.txt  { access_log off; log_not_found off; }
    
        access_log off;
        error_log  /var/log/nginx/'"${SERVNAME}"'.app-error.log error;
    
        # allow larger file uploads and longer script runtimes
            client_max_body_size 100m;
        client_body_timeout 120s;
    
        sendfile off;
    
        location ~ \.php$ {
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
            fastcgi_index index.php;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_intercept_errors off;
            fastcgi_buffer_size 16k;
            fastcgi_buffers 4 16k;
            fastcgi_connect_timeout 300;
            fastcgi_send_timeout 300;
            fastcgi_read_timeout 300;
        }
    
        location ~ /\.ht {
            deny all;
        }
        location ~ /.well-known {
            allow all;
        }
    }
' | sudo -E tee /etc/nginx/sites-available/$SERVNAME.conf >/dev/null 2>&1

sudo ln -s /etc/nginx/sites-available/$SERVNAME.conf /etc/nginx/sites-enabled/$SERVNAME.conf
sudo ln -s /var/web /var/www/$SERVNAME/html
sudo service nginx restart
    clear
    output "Now for the database fun!"
    # create database
    password=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`  
    Q1="CREATE DATABASE IF NOT EXISTS yiimpfrontend;"
    Q2="GRANT ALL ON *.* TO 'panel'@'localhost' IDENTIFIED BY '$password';"
    Q3="FLUSH PRIVILEGES;"
    SQL="${Q1}${Q2}${Q3}"
    
    sudo mysql -u root -p="" -e "$SQL"
    # create stratum user
    password2=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    Q1="GRANT ALL ON *.* TO 'stratum'@'localhost' IDENTIFIED BY '$password2';"
    Q2="FLUSH PRIVILEGES;"
    SQL="${Q1}${Q2}"
    
    sudo mysql -u root -p="" -e "$SQL"  
 echo '
[clienthost1]
user=panel
password='"${password}"'
database=yiimpfrontend
host=localhost
[clienthost2]
user=stratum
password='"${password2}"'
database=yiimpfrontend
host=localhost
[mysql]
user=root
password='"${rootpasswd}"'
' | sudo -E tee ~/.my.cnf >/dev/null 2>&1
      sudo chmod 0600 ~/.my.cnf
    
 

    output "Database 'yiimpfrontend' and users 'panel' and 'stratum' created with password $password and $password2, will be saved for you"
    output "Peforming the SQL import"
    cd ~
    cd yiimp/sql
    # import sql dump
    sudo zcat 2016-04-03-yaamp.sql.gz | sudo mysql --defaults-group-suffix=host1
    clear
    output "Generating a basic serverconfig.php"
    # make config file
echo '
<?php
ini_set('"'"'date.timezone'"'"', '"'"'UTC'"'"');

define('"'"'YAAMP_LOGS'"'"', '"'"'/var/log'"'"');
define('"'"'YAAMP_HTDOCS'"'"', '"'"'/var/web'"'"');
define('"'"'YAAMP_BIN'"'"', '"'"'/var/bin'"'"');

define('"'"'YAAMP_DBHOST'"'"', '"'"'localhost'"'"');
define('"'"'YAAMP_DBNAME'"'"', '"'"'yiimpfrontend'"'"');
define('"'"'YAAMP_DBUSER'"'"', '"'"'panel'"'"');
define('"'"'YAAMP_DBPASSWORD'"'"', '"'"''"${password}"''"'"');

define('"'"'YAAMP_PRODUCTION'"'"', true);
define('"'"'YAAMP_RENTAL'"'"', true);
define('"'"'YAAMP_LIMIT_ESTIMATE'"'"', false);

define('"'"'YAAMP_FEES_MINING'"'"', 0.5);
define('"'"'YAAMP_FEES_EXCHANGE'"'"', 2);
define('"'"'YAAMP_FEES_RENTING'"'"', 2);
define('"'"'YAAMP_TXFEE_RENTING_WD'"'"', 0.002);
define('"'"'YAAMP_PAYMENTS_FREQ'"'"', 3*60*60);
define('"'"'YAAMP_PAYMENTS_MINI'"'"', 0.001);

define('"'"'YAAMP_ALLOW_EXCHANGE'"'"', false);
define('"'"'YIIMP_PUBLIC_EXPLORER'"'"', true);
define('"'"'YIIMP_PUBLIC_BENCHMARK'"'"', false);
define('"'"'YIIMP_FIAT_ALTERNATIVE'"'"', '"'"'USD'"'"'); // USD is main

define('"'"'YAAMP_USE_NICEHASH_API'"'"', false);

define('"'"'YAAMP_BTCADDRESS'"'"', '"'"'1Auhps1mHZQpoX4mCcVL8odU81VakZQ6dR'"'"');
define('"'"'YAAMP_SITE_URL'"'"', '"'"''"${SERVNAME}"''"'"');
define('"'"'YAAMP_STRATUM_URL'"'"', YAAMP_SITE_URL); // change if your stratum server is on a different host
define('"'"'YAAMP_SITE_NAME'"'"', '"'"'YiiMP'"'"');
define('"'"'YAAMP_ADMIN_EMAIL'"'"', '"'"''"${EMAIL}"''"'"');
define('"'"'YAAMP_ADMIN_IP'"'"', '"'"''"'"'); // samples: "80.236.118.26,90.234.221.11" or "10.0.0.1/8"
define('"'"'YAAMP_ADMIN_WEBCONSOLE'"'"', true);
define('"'"'YAAMP_NOTIFY_NEW_COINS'"'"', true);
define('"'"'YAAMP_DEFAULT_ALGO'"'"', '"'"'x11'"'"');

define('"'"'YAAMP_USE_NGINX'"'"', true);

// Exchange public keys (private keys are in a separate config file)
define('"'"'EXCH_CRYPTOPIA_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_POLONIEX_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_BITTREX_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_BLEUTRADE_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_BTER_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_YOBIT_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_CCEX_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_COINMARKETS_USER'"'"', '"'"''"'"');
define('"'"'EXCH_COINMARKETS_PIN'"'"', '"'"''"'"');
define('"'"'EXCH_BITSTAMP_ID'"'"','"'"''"'"');
define('"'"'EXCH_BITSTAMP_KEY'"'"','"'"''"'"');
define('"'"'EXCH_HITBTC_KEY'"'"','"'"''"'"');
define('"'"'EXCH_KRAKEN_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_LIVECOIN_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_NOVA_KEY'"'"', '"'"''"'"');

// Automatic withdraw to Yaamp btc wallet if btc balance > 0.3
define('"'"'EXCH_AUTO_WITHDRAW'"'"', 0.3);

// nicehash keys deposit account & amount to deposit at a time
define('"'"'NICEHASH_API_KEY'"'"','"'"'521c254d-8cc7-4319-83d2-ac6c604b5b49'"'"');
define('"'"'NICEHASH_API_ID'"'"','"'"'9205'"'"');
define('"'"'NICEHASH_DEPOSIT'"'"','"'"'3J9tapPoFCtouAZH7Th8HAPsD8aoykEHzk'"'"');
define('"'"'NICEHASH_DEPOSIT_AMOUNT'"'"','"'"'0.01'"'"');


$cold_wallet_table = array(
	'"'"'1C23KmLeCaQSLLyKVykHEUse1R7jRDv9j9'"'"' => 0.10,
);

// Sample fixed pool fees
$configFixedPoolFees = array(
        '"'"'zr5'"'"' => 2.0,
        '"'"'scrypt'"'"' => 20.0,
        '"'"'sha256'"'"' => 5.0,
);

// Sample custom stratum ports
$configCustomPorts = array(
//	'"'"'x11'"'"' => 7000,
);

// mBTC Coefs per algo (default is 1.0)
$configAlgoNormCoef = array(
//	'"'"'x11'"'"' => 5.0,
);
' | sudo -E tee /var/web/serverconfig.php >/dev/null 2>&1

  output "Final Directory permissions"
sudo usermod -aG www-data $whoami
sudo chown -R www-data:www-data /var/www/$SERVNAME/html
sudo chown -R www-data:www-data /var/log
sudo chown -R www-data:www-data /var/stratum
sudo chmod -R 775 /var/www/$SERVNAME/html
sudo chmod -R 775 /var/log
sudo chmod -R 775 /var/stratum
sudo chown -R www-data:www-data /var/web
sudo chmod -R 775 /var/web
sudo service nginx restart
    
