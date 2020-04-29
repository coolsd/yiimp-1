#!/bin/bash
################################################################################
# Original Author:   crombiecrunch
# Fork Author: manfromafar
# Current Author: Xavatar (https://github.com/xavatar/yiimp_install_scrypt)
# Web: https://www.xavatar.com  
#
# Program:
#   Install yiimp on Ubuntu 16.04 running Nginx, MariaDB, and php7.0
# 
# 
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

    #Add user group sudo + no password
    whoami=`whoami`
    sudo usermod -aG sudo ${whoami}
    echo '# yiimp
    # It needs passwordless sudo functionality.
    '""''"${whoami}"''""' ALL=(ALL) NOPASSWD:ALL
    ' | sudo -E tee /etc/sudoers.d/${whoami} >/dev/null 2>&1

    #Copy needed files
    sudo cp -r ../utils/screen-scrypt.sh /etc/
    sudo chmod +x /etc/screen-scrypt.sh


    clear
    output " "
    output "Yiimp Install Script v0.1"
    output "Install yiimp on Ubuntu 16.04 running Nginx, MariaDB, and php7.0"
    output " "
    sleep 3
    
    output " "
    output " "
    output "Make sure you double check before hitting enter! Only one shot at these!"
    output " "
    read -e -p "Enter time zone (e.g. America/New_York) : " TIME
    read -e -p "Server name (no http:// or www. just : example.com or pool.example.com) : " server_name
    read -e -p "Are you using a subdomain (pool.example.com?) [y/N] : " sub_domain
    read -e -p "Enter support email (e.g. admin@example.com) : " EMAIL
    read -e -p "Set Pool to AutoExchange? i.e. mine any coin with BTC address? [y/N] : " BTC
    read -e -p "Please enter a new location for /site/adminRights this is to customize the Admin Panel entrance url (e.g. myAdminpanel) : " admin_panel
    read -e -p "Enter the Public IP of the system you will use to access the admin panel (http://www.whatsmyip.org/) : " Public
    read -e -p "Install Fail2ban? [Y/n] : " install_fail2ban
    read -e -p "Install UFW and configure ports? [Y/n] : " UFW
    read -e -p "Install LetsEncrypt SSL? IMPORTANT! You MUST have your domain name pointed to this server prior to running the script!! [Y/n]: " ssl_install
    
    
    # Update package and Upgrade Ubuntu
    output " "
    output "Updating system and installing required packages."
    output " "
    sleep 3
        
    sudo apt-get -y update 
    sudo apt-get -y upgrade
    sudo apt-get -y autoremove
    
    
    # Switch Aptitude
    output " "
    output "Switching to Aptitude"
    output " "
    sleep 3
    
    sudo apt-get -y install aptitude
    
    
    # Installing Nginx
    output " "
    output "Installing Nginx server."
    output " "
    sleep 3
    
    sudo aptitude -y install nginx
    sudo rm /etc/nginx/sites-enabled/default
    sudo systemctl start nginx.service
    sudo systemctl enable nginx.service
    sudo systemctl start cron.service
    sudo systemctl enable cron.service
	

    # Making Nginx a bit hard
    echo 'map $http_user_agent $blockedagent {
default         0;
~*malicious     1;
~*bot           1;
~*backdoor      1;
~*crawler       1;
~*bandit        1;
}
' | sudo -E tee /etc/nginx/blockuseragents.rules >/dev/null 2>&1
    
    
    # Installing Mariadb
    output " "
    output "Installing Mariadb Server."
    output " "
    sleep 3
        
    # Create random password
    rootpasswd=$(openssl rand -base64 12)
    export DEBIAN_FRONTEND="noninteractive"
    sudo aptitude -y install mariadb-server
    sudo systemctl start mysql
    sudo systemctl enable mysql
    
    
    # Installing Installing php7.x
    output " "
    output "Installing php7.x"
    output " "
    sleep 3
    
    sudo aptitude -y install php7.0-fpm
    sudo aptitude -y install php7.0-opcache php7.0-fpm php7.0 php7.0-common php7.0-gd php7.0-mysql php7.0-imap php7.0-cli php7.0-cgi php-pear php-auth php7.0-mcrypt mcrypt imagemagick libruby php7.0-curl php7.0-intl php7.0-pspell php7.0-recode php7.0-sqlite3 php7.0-tidy php7.0-xmlrpc php7.0-xsl memcached php-memcache php-imagick php-gettext php7.0-zip php7.0-mbstring
    sudo phpenmod mcrypt
    sudo phpenmod mbstring
    sudo systemctl start php7.0-fpm.service
    
    
    # Installing other needed files
    output " "
    output "Installing other needed files"
    output " "
    sleep 3
    
    sudo aptitude -y install libgmp3-dev
    sudo aptitude -y install libmysqlclient-dev
    sudo aptitude -y install libcurl4-gnutls-dev
    sudo aptitude -y install libkrb5-dev
    sudo aptitude -y install libldap2-dev
    sudo aptitude -y install libidn11-dev
    sudo aptitude -y install gnutls-dev
    sudo aptitude -y install librtmp-dev
    sudo aptitude -y install sendmail
    sudo aptitude -y install mutt
    sudo aptitude -y install git screen
    sudo aptitude -y install pwgen -y
	
    
    # Installing Package to compile crypto currency
    output " "
    output "Installing Package to compile crypto currency"
    output " "
    sleep 3
    
    sudo aptitude -y install software-properties-common build-essential
    sudo aptitude -y install libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git cmake libboost-all-dev zlib1g-dev libz-dev libseccomp-dev libcap-dev libminiupnpc-dev gettext
    sudo aptitude -y install libminiupnpc10 libzmq5
    sudo aptitude -y install libcanberra-gtk-module libqrencode-dev libzmq3-dev
    sudo aptitude -y install libqt5gui5 libqt5core5a libqt5webkit5-dev libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler
    sudo add-apt-repository -y ppa:bitcoin/bitcoin
    sudo apt-get -y update
    sudo apt-get install -y libdb4.8-dev libdb4.8++-dev libdb5.3 libdb5.3++
       
    
    # Generating Random Passwords
    password=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    password2=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    AUTOGENERATED_PASS=`pwgen -c -1 20`
    
    
    # Test Email
    output " "
    output "Testing to see if server emails are sent"
    output " "
    sleep 3
    
    if [[ "$root_email" != "" ]]; then
        echo $root_email > sudo tee --append ~/.email
        echo $root_email > sudo tee --append ~/.forward

    if [[ ("$send_email" == "y" || "$send_email" == "Y" || "$send_email" == "") ]]; then
        echo "This is a mail test for the SMTP Service." > sudo tee --append /tmp/email.message
        echo "You should receive this !" >> sudo tee --append /tmp/email.message
        echo "" >> sudo tee --append /tmp/email.message
        echo "Cheers" >> sudo tee --append /tmp/email.message
        sudo sendmail -s "SMTP Testing" $root_email < sudo tee --append /tmp/email.message

        sudo rm -f /tmp/email.message
        echo "Mail sent"
    fi
    fi
    
    
    # Installing Fail2Ban & UFW
    output " "
    output "Some optional installs (Fail2Ban & UFW)"
    output " "
    sleep 3
    
    
    if [[ ("$install_fail2ban" == "y" || "$install_fail2ban" == "Y" || "$install_fail2ban" == "") ]]; then
    sudo aptitude -y install fail2ban
    fi
    if [[ ("$UFW" == "y" || "$UFW" == "Y" || "$UFW" == "") ]]; then
    sudo apt-get install ufw
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    sudo ufw allow http
    sudo ufw allow https
    sudo ufw allow 3333/tcp
    sudo ufw allow 3339/tcp
    sudo ufw allow 3334/tcp
    sudo ufw allow 3433/tcp
    sudo ufw allow 3555/tcp
    sudo ufw allow 3556/tcp
    sudo ufw allow 3573/tcp
    sudo ufw allow 3535/tcp
    sudo ufw allow 3533/tcp
    sudo ufw allow 3553/tcp
    sudo ufw allow 3633/tcp
    sudo ufw allow 3733/tcp
    sudo ufw allow 3636/tcp
    sudo ufw allow 3737/tcp
    sudo ufw allow 3739/tcp
    sudo ufw allow 3747/tcp
    sudo ufw allow 3833/tcp
    sudo ufw allow 3933/tcp
    sudo ufw allow 4033/tcp
    sudo ufw allow 4133/tcp
    sudo ufw allow 4233/tcp
    sudo ufw allow 4234/tcp
    sudo ufw allow 4333/tcp
    sudo ufw allow 4433/tcp
    sudo ufw allow 4533/tcp
    sudo ufw allow 4553/tcp
    sudo ufw allow 4633/tcp
    sudo ufw allow 4733/tcp
    sudo ufw allow 4833/tcp
    sudo ufw allow 4933/tcp
    sudo ufw allow 5033/tcp
    sudo ufw allow 5133/tcp
    sudo ufw allow 5233/tcp
    sudo ufw allow 5333/tcp
    sudo ufw allow 5433/tcp
    sudo ufw allow 5533/tcp
    sudo ufw allow 5733/tcp
    sudo ufw allow 5743/tcp
    sudo ufw allow 3252/tcp
    sudo ufw allow 5755/tcp
    sudo ufw allow 5766/tcp
    sudo ufw allow 5833/tcp
    sudo ufw allow 5933/tcp
    sudo ufw allow 6033/tcp
    sudo ufw allow 5034/tcp
    sudo ufw allow 6133/tcp
    sudo ufw allow 6233/tcp
    sudo ufw allow 6333/tcp
    sudo ufw allow 6433/tcp
    sudo ufw allow 7433/tcp
    sudo ufw allow 8333/tcp
    sudo ufw allow 8463/tcp
    sudo ufw allow 8433/tcp
    sudo ufw allow 8533/tcp
    sudo ufw --force enable    
    fi
    
    
    # Installing PhpMyAdmin
    output " "
    output "Installing phpmyadmin"
    output " "
    sleep 3
    
    echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect" | sudo debconf-set-selections
    echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | sudo debconf-set-selections
    echo "phpmyadmin phpmyadmin/mysql/admin-user string root" | sudo debconf-set-selections
    echo "phpmyadmin phpmyadmin/mysql/admin-pass password $rootpasswd" | sudo debconf-set-selections
    echo "phpmyadmin phpmyadmin/mysql/app-pass password $AUTOGENERATED_PASS" | sudo debconf-set-selections
    echo "phpmyadmin phpmyadmin/app-password-confirm password $AUTOGENERATED_PASS" | sudo debconf-set-selections
    sudo aptitude -y install phpmyadmin
	
	
    # Installing Yiimp
    output " "
    output " Installing Yiimp"
    output " "
    output "Grabbing yiimp fron Github, building files and setting file structure."
    output " "
    sleep 3
    
    
    # Generating Random Password for stratum
    blckntifypass=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    
    # Compil Blocknotify
    cd ~
    git clone https://github.com/tpruvot/yiimp.git
    cd $HOME/yiimp/blocknotify
    sudo sed -i 's/tu8tu5/'$blckntifypass'/' blocknotify.cpp
    sudo make
    
    # Compil iniparser
    cd $HOME/yiimp/stratum/iniparser
    sudo make
    
    # Compil Stratum
    cd $HOME/yiimp/stratum
    if [[ ("$BTC" == "y" || "$BTC" == "Y") ]]; then
    sudo sed -i 's/CFLAGS += -DNO_EXCHANGE/#CFLAGS += -DNO_EXCHANGE/' $HOME/yiimp/stratum/Makefile
    sudo make
    fi
    sudo make
    
    # Copy Files (Blocknotify,iniparser,Stratum)
    cd $HOME/yiimp
    sudo sed -i 's/AdminRights/'$admin_panel'/' $HOME/yiimp/web/yaamp/modules/site/SiteController.php
    sudo cp -r $HOME/yiimp/web /var/
    sudo mkdir -p /var/stratum
    cd $HOME/yiimp/stratum
    sudo cp -a config.sample/. /var/stratum/config
    sudo cp -r stratum /var/stratum
    sudo cp -r run.sh /var/stratum
    cd $HOME/yiimp
    sudo cp -r $HOME/yiimp/bin/. /bin/
    sudo cp -r $HOME/yiimp/blocknotify/blocknotify /usr/bin/
    sudo cp -r $HOME/yiimp/blocknotify/blocknotify /var/stratum/
    sudo mkdir -p /etc/yiimp
    sudo mkdir -p /$HOME/backup/
    #fixing yiimp
    sudo sed -i "s|ROOTDIR=/data/yiimp|ROOTDIR=/var|g" /bin/yiimp
    #fixing run.sh
    sudo rm -r /var/stratum/config/run.sh
    echo '
#!/bin/bash
ulimit -n 10240
ulimit -u 10240
cd /var/stratum
while true; do
./stratum /var/stratum/config/$1
sleep 2
done
exec bash
' | sudo -E tee /var/stratum/config/run.sh >/dev/null 2>&1
    sudo chmod +x /var/stratum/config/run.sh


    # Update Timezone
    output " "
    output "Update default timezone."
    output " "
    
    # Check if link file
    sudo [ -L /etc/localtime ] &&  sudo unlink /etc/localtime
    
    # Update time zone
    sudo ln -sf /usr/share/zoneinfo/$TIME /etc/localtime
    sudo aptitude -y install ntpdate
    
    # Write time to clock.
    sudo hwclock -w
    
    
    # Making Web Server Magic Happen
    output " "
    output "Making Web Server Magic Happen!"
    output " "
    
    # Adding user to group, creating dir structure, setting permissions
    sudo mkdir -p /var/www/$server_name/html 
    
    
    # Creating webserver initial config file
    output " "
    output "Creating webserver initial config file"
    output " "
    
    if [[ ("$sub_domain" == "y" || "$sub_domain" == "Y") ]]; then
    echo 'include /etc/nginx/blockuseragents.rules;
	server {
	if ($blockedagent) {
                return 403;
        }
        if ($request_method !~ ^(GET|HEAD|POST)$) {
        return 444;
        }
        listen 80;
        listen [::]:80;
        server_name '"${server_name}"';
        root "/var/www/'"${server_name}"'/html/web";
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
    
        access_log /var/log/nginx/'"${server_name}"'.app-access.log;
        error_log /var/log/nginx/'"${server_name}"'.app-error.log;
    
        # allow larger file uploads and longer script runtimes
 	client_body_buffer_size  50k;
        client_header_buffer_size 50k;
        client_max_body_size 50k;
        large_client_header_buffers 2 50k;
        sendfile off;
    
        location ~ ^/index\.php$ {
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
	    try_files $uri $uri/ =404;
        }
		location ~ \.php$ {
        	return 404;
        }
		location ~ \.sh {
		return 404;
        }
		location ~ /\.ht {
		deny all;
        }
		location ~ /.well-known {
		allow all;
        }
		location /phpmyadmin {
  		root /usr/share/;
  		index index.php;
  		try_files $uri $uri/ =404;
  		location ~ ^/phpmyadmin/(doc|sql|setup)/ {
    		deny all;
  	}
  		location ~ /phpmyadmin/(.+\.php)$ {
    		fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    		include fastcgi_params;
    		include snippets/fastcgi-php.conf;
  	}
 }
 }
' | sudo -E tee /etc/nginx/sites-available/$server_name.conf >/dev/null 2>&1

    sudo ln -s /etc/nginx/sites-available/$server_name.conf /etc/nginx/sites-enabled/$server_name.conf
    sudo ln -s /var/web /var/www/$server_name/html
    sudo systemctl reload php7.0-fpm.service
    sudo systemctl restart nginx.service
	
    if [[ ("$ssl_install" == "y" || "$ssl_install" == "Y" || "$ssl_install" == "") ]]; then
    
    # Install SSL (with SubDomain)
    output " "
    output "Install LetsEncrypt and setting SSL (with SubDomain)"
    output " "
    
    sudo aptitude -y install letsencrypt
    sudo letsencrypt certonly -a webroot --webroot-path=/var/web --email "$EMAIL" --agree-tos -d "$server_name"
    sudo rm /etc/nginx/sites-available/$server_name.conf
    sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
    # I am SSL Man!
	echo 'include /etc/nginx/blockuseragents.rules;
	server {
	if ($blockedagent) {
                return 403;
        }
        if ($request_method !~ ^(GET|HEAD|POST)$) {
        return 444;
        }
        listen 80;
        listen [::]:80;
        server_name '"${server_name}"';
    	# enforce https
        return 301 https://$server_name$request_uri;
	}
	
	server {
	if ($blockedagent) {
                return 403;
        }
        if ($request_method !~ ^(GET|HEAD|POST)$) {
        return 444;
        }
            listen 443 ssl http2;
            listen [::]:443 ssl http2;
            server_name '"${server_name}"';
        
            root /var/www/'"${server_name}"'/html/web;
            index index.php;
        
            access_log /var/log/nginx/'"${server_name}"'.app-access.log;
            error_log  /var/log/nginx/'"${server_name}"'.app-error.log;
        
            # allow larger file uploads and longer script runtimes
 	client_body_buffer_size  50k;
        client_header_buffer_size 50k;
        client_max_body_size 50k;
        large_client_header_buffers 2 50k;
        sendfile off;
        
            # strengthen ssl security
            ssl_certificate /etc/letsencrypt/live/'"${server_name}"'/fullchain.pem;
            ssl_certificate_key /etc/letsencrypt/live/'"${server_name}"'/privkey.pem;
            ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
            ssl_prefer_server_ciphers on;
            ssl_session_cache shared:SSL:10m;
            ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:ECDHE-RSA-AES128-GCM-SHA256:AES256+EECDH:DHE-RSA-AES128-GCM-SHA256:AES256+EDH:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4";
            ssl_dhparam /etc/ssl/certs/dhparam.pem;
        
            # Add headers to serve security related headers
            add_header Strict-Transport-Security "max-age=15768000; preload;";
            add_header X-Content-Type-Options nosniff;
            add_header X-XSS-Protection "1; mode=block";
            add_header X-Robots-Tag none;
            add_header Content-Security-Policy "frame-ancestors 'self'";
        
        location / {
        try_files $uri $uri/ /index.php?$args;
        }
        location @rewrite {
        rewrite ^/(.*)$ /index.php?r=$1;
        }
    
        
            location ~ ^/index\.php$ {
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
                include /etc/nginx/fastcgi_params;
	    	try_files $uri $uri/ =404;
        }
		location ~ \.php$ {
        	return 404;
        }
		location ~ \.sh {
		return 404;
        }
        
            location ~ /\.ht {
                deny all;
            }
	    location /phpmyadmin {
  		root /usr/share/;
  		index index.php;
  		try_files $uri $uri/ =404;
  		location ~ ^/phpmyadmin/(doc|sql|setup)/ {
    		deny all;
  	}
  		location ~ /phpmyadmin/(.+\.php)$ {
    		fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    		include fastcgi_params;
    		include snippets/fastcgi-php.conf;
  	}
 }
 }
        
' | sudo -E tee /etc/nginx/sites-available/$server_name.conf >/dev/null 2>&1
	fi
	
	sudo systemctl reload php7.0-fpm.service
	sudo systemctl restart nginx.service
	
	else
	echo 'include /etc/nginx/blockuseragents.rules;
	server {
	if ($blockedagent) {
                return 403;
        }
        if ($request_method !~ ^(GET|HEAD|POST)$) {
        return 444;
        }
        listen 80;
        listen [::]:80;
        server_name '"${server_name}"' www.'"${server_name}"';
        root "/var/www/'"${server_name}"'/html/web";
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
    
        access_log /var/log/nginx/'"${server_name}"'.app-access.log;
        error_log /var/log/nginx/'"${server_name}"'.app-error.log;
    
        # allow larger file uploads and longer script runtimes
 	client_body_buffer_size  50k;
        client_header_buffer_size 50k;
        client_max_body_size 50k;
        large_client_header_buffers 2 50k;
        sendfile off;
    
        location ~ ^/index\.php$ {
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
	    try_files $uri $uri/ =404;
        }
		location ~ \.php$ {
        	return 404;
        }
		location ~ \.sh {
		return 404;
        }
		location ~ /\.ht {
		deny all;
        }
		location ~ /.well-known {
		allow all;
        }
		location /phpmyadmin {
  		root /usr/share/;
  		index index.php;
  		try_files $uri $uri/ =404;
  		location ~ ^/phpmyadmin/(doc|sql|setup)/ {
    		deny all;
  	}
  		location ~ /phpmyadmin/(.+\.php)$ {
    		fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    		include fastcgi_params;
    		include snippets/fastcgi-php.conf;
  	}
 }
 }
' | sudo -E tee /etc/nginx/sites-available/$server_name.conf >/dev/null 2>&1

    sudo ln -s /etc/nginx/sites-available/$server_name.conf /etc/nginx/sites-enabled/$server_name.conf
    sudo ln -s /var/web /var/www/$server_name/html
    sudo systemctl reload php7.0-fpm.service
    sudo systemctl restart nginx.service
	
    if [[ ("$ssl_install" == "y" || "$ssl_install" == "Y" || "$ssl_install" == "") ]]; then
    
    # Install SSL (without SubDomain)
    output " "
    output "Install LetsEncrypt and setting SSL (without SubDomain)"
    output " "
    sleep 3
    
    sudo aptitude -y install letsencrypt
    sudo letsencrypt certonly -a webroot --webroot-path=/var/web --email "$EMAIL" --agree-tos -d "$server_name" -d www."$server_name"
    sudo rm /etc/nginx/sites-available/$server_name.conf
    sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
    # I am SSL Man!
	echo 'include /etc/nginx/blockuseragents.rules;
	server {
	if ($blockedagent) {
                return 403;
        }
        if ($request_method !~ ^(GET|HEAD|POST)$) {
        return 444;
        }
        listen 80;
        listen [::]:80;
        server_name '"${server_name}"';
    	# enforce https
        return 301 https://$server_name$request_uri;
	}
	
	server {
	if ($blockedagent) {
                return 403;
        }
        if ($request_method !~ ^(GET|HEAD|POST)$) {
        return 444;
        }
            listen 443 ssl http2;
            listen [::]:443 ssl http2;
            server_name '"${server_name}"' www.'"${server_name}"';
        
            root /var/www/'"${server_name}"'/html/web;
            index index.php;
        
            access_log /var/log/nginx/'"${server_name}"'.app-access.log;
            error_log  /var/log/nginx/'"${server_name}"'.app-error.log;
        
            # allow larger file uploads and longer script runtimes
 	client_body_buffer_size  50k;
        client_header_buffer_size 50k;
        client_max_body_size 50k;
        large_client_header_buffers 2 50k;
        sendfile off;
        
            # strengthen ssl security
            ssl_certificate /etc/letsencrypt/live/'"${server_name}"'/fullchain.pem;
            ssl_certificate_key /etc/letsencrypt/live/'"${server_name}"'/privkey.pem;
            ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
            ssl_prefer_server_ciphers on;
            ssl_session_cache shared:SSL:10m;
            ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:ECDHE-RSA-AES128-GCM-SHA256:AES256+EECDH:DHE-RSA-AES128-GCM-SHA256:AES256+EDH:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4";
            ssl_dhparam /etc/ssl/certs/dhparam.pem;
        
            # Add headers to serve security related headers
            add_header Strict-Transport-Security "max-age=15768000; preload;";
            add_header X-Content-Type-Options nosniff;
            add_header X-XSS-Protection "1; mode=block";
            add_header X-Robots-Tag none;
            add_header Content-Security-Policy "frame-ancestors 'self'";
        
        location / {
        try_files $uri $uri/ /index.php?$args;
        }
        location @rewrite {
        rewrite ^/(.*)$ /index.php?r=$1;
        }
    
        
            location ~ ^/index\.php$ {
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
                include /etc/nginx/fastcgi_params;
	    	try_files $uri $uri/ =404;
        }
		location ~ \.php$ {
        	return 404;
        }
		location ~ \.sh {
		return 404;
        }
        
            location ~ /\.ht {
                deny all;
            }
	    location /phpmyadmin {
  		root /usr/share/;
  		index index.php;
  		try_files $uri $uri/ =404;
  		location ~ ^/phpmyadmin/(doc|sql|setup)/ {
    		deny all;
  	}
  		location ~ /phpmyadmin/(.+\.php)$ {
    		fastcgi_pass unix:/run/php/php7.0-fpm.sock;
    		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    		include fastcgi_params;
    		include snippets/fastcgi-php.conf;
  	}
 }
 }
        
' | sudo -E tee /etc/nginx/sites-available/$server_name.conf >/dev/null 2>&1
	
    fi
    sudo systemctl reload php7.0-fpm.service
    sudo systemctl restart nginx.service
    fi
    
    
    # Config Database
    output " "
    output "Now for the database fun!"
    output " "
    sleep 3
    
    # Create database
    Q1="CREATE DATABASE IF NOT EXISTS yiimpfrontend;"
    Q2="GRANT ALL ON *.* TO 'panel'@'localhost' IDENTIFIED BY '$password';"
    Q3="FLUSH PRIVILEGES;"
    SQL="${Q1}${Q2}${Q3}"
    sudo mysql -u root -p="" -e "$SQL"
    
    # Create stratum user
    Q1="GRANT ALL ON *.* TO 'stratum'@'localhost' IDENTIFIED BY '$password2';"
    Q2="FLUSH PRIVILEGES;"
    SQL="${Q1}${Q2}"
    sudo mysql -u root -p="" -e "$SQL"  
    
    #Create my.cnf
    
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
[myphpadmin]
user=phpmyadmin
password='"${AUTOGENERATED_PASS}"'
[mysql]
user=root
password='"${rootpasswd}"'
' | sudo -E tee ~/.my.cnf >/dev/null 2>&1
      sudo chmod 0600 ~/.my.cnf

    # Create keys file
    echo '  
    <?php
/* Sample config file to put in /etc/yiimp/keys.php */
define('"'"'YIIMP_MYSQLDUMP_USER'"'"', '"'"'panel'"'"');
define('"'"'YIIMP_MYSQLDUMP_PASS'"'"', '"'"''"${password}"''"'"');
define('"'"'YIIMP_MYSQLDUMP_PATH'"'"', '"'"''"/var/yiimp/sauv"''"'"');
/* Keys required to create/cancel orders and access your balances/deposit addresses */
define('"'"'EXCH_BITTREX_SECRET'"'"', '"'"'<my_bittrex_api_secret_key>'"'"');
define('"'"'EXCH_BITSTAMP_SECRET'"'"','"'"''"'"');
define('"'"'EXCH_BLEUTRADE_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_BTER_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_CCEX_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_COINMARKETS_PASS'"'"', '"'"''"'"');
define('"'"'EXCH_CRYPTOPIA_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_EMPOEX_SECKEY'"'"', '"'"''"'"');
define('"'"'EXCH_HITBTC_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_KRAKEN_SECRET'"'"','"'"''"'"');
define('"'"'EXCH_LIVECOIN_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_NOVA_SECRET'"'"','"'"''"'"');
define('"'"'EXCH_POLONIEX_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_YOBIT_SECRET'"'"', '"'"''"'"');
' | sudo -E tee /etc/yiimp/keys.php >/dev/null 2>&1
 
 
    # Peforming the SQL import
    output " "
    output "Database 'yiimpfrontend' and users 'panel' and 'stratum' created with password $password and $password2, will be saved for you"
    output " "
    output "Peforming the SQL import"
    output " "
    sleep 3
    
    cd ~
    cd yiimp/sql
    
    # Import sql dump
    sudo zcat 2016-04-03-yaamp.sql.gz | sudo mysql --defaults-group-suffix=host1
    
    # Oh the humanity!
    sudo mysql --defaults-group-suffix=host1 --force < 2016-04-24-market_history.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2016-04-27-settings.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2016-05-11-coins.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2016-05-15-benchmarks.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2016-05-23-bookmarks.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2016-06-01-notifications.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2016-06-04-bench_chips.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2016-11-23-coins.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2017-02-05-benchmarks.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2017-03-31-earnings_index.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2017-05-accounts_case_swaptime.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2017-06-payouts_coinid_memo.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2017-09-notifications.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2017-10-bookmarks.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2017-11-segwit.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2018-01-stratums_ports.sql
    sudo mysql --defaults-group-suffix=host1 --force < 2018-02-coins_getinfo.sql
    
    
    # Generating a basic Yiimp serverconfig.php
    output " "
    output "Generating a basic Yiimp serverconfig.php"
    output " "
    sleep 3
    
    # Make config file
echo '
<?php

ini_set('"'"'date.timezone'"'"', '"'"'UTC'"'"');

define('"'"'YAAMP_LOGS'"'"', '"'"'/var/log/yiimp'"'"');
define('"'"'YAAMP_HTDOCS'"'"', '"'"'/var/web'"'"');

define('"'"'YAAMP_BIN'"'"', '"'"'/var/bin'"'"');

define('"'"'YAAMP_DBHOST'"'"', '"'"'localhost'"'"');
define('"'"'YAAMP_DBNAME'"'"', '"'"'yiimpfrontend'"'"');
define('"'"'YAAMP_DBUSER'"'"', '"'"'panel'"'"');
define('"'"'YAAMP_DBPASSWORD'"'"', '"'"''"${password}"''"'"');

define('"'"'YAAMP_PRODUCTION'"'"', true);
define('"'"'YAAMP_RENTAL'"'"', false);

define('"'"'YAAMP_LIMIT_ESTIMATE'"'"', false);

define('"'"'YAAMP_FEES_MINING'"'"', 0.5);
define('"'"'YAAMP_FEES_EXCHANGE'"'"', 2);
define('"'"'YAAMP_FEES_RENTING'"'"', 2);
define('"'"'YAAMP_TXFEE_RENTING_WD'"'"', 0.002);

define('"'"'YAAMP_PAYMENTS_FREQ'"'"', 2*60*60);
define('"'"'YAAMP_PAYMENTS_MINI'"'"', 0.001);

define('"'"'YAAMP_ALLOW_EXCHANGE'"'"', false);
define('"'"'YIIMP_PUBLIC_EXPLORER'"'"', true);
define('"'"'YIIMP_PUBLIC_BENCHMARK'"'"', false);

define('"'"'YIIMP_FIAT_ALTERNATIVE'"'"', '"'"'USD'"'"'); // USD is main
define('"'"'YAAMP_USE_NICEHASH_API'"'"', false);

define('"'"'YAAMP_BTCADDRESS'"'"', '"'"'1C1hnjk3WhuAvUN6Ny6LTxPD3rwSZwapW7'"'"');

define('"'"'YAAMP_SITE_URL'"'"', '"'"''"${server_name}"''"'"');
define('"'"'YAAMP_STRATUM_URL'"'"', YAAMP_SITE_URL); // change if your stratum server is on a different host
define('"'"'YAAMP_SITE_NAME'"'"', '"'"'YIIMP'"'"');
define('"'"'YAAMP_ADMIN_EMAIL'"'"', '"'"''"${EMAIL}"''"'"');
define('"'"'YAAMP_ADMIN_IP'"'"', '"'"''"${Public}"''"'"'); // samples: "80.236.118.26,90.234.221.11" or "10.0.0.1/8"

define('"'"'YAAMP_ADMIN_WEBCONSOLE'"'"', true);
define('"'"'YAAMP_CREATE_NEW_COINS'"'"', false);
define('"'"'YAAMP_NOTIFY_NEW_COINS'"'"', false);

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
define('"'"'NICEHASH_API_KEY'"'"','"'"'f96c65a7-3d2f-4f3a-815c-cacf00674396'"'"');
define('"'"'NICEHASH_API_ID'"'"','"'"'825979'"'"');
define('"'"'NICEHASH_DEPOSIT'"'"','"'"'3ABoqBjeorjzbyHmGMppM62YLssUgJhtuf'"'"');
define('"'"'NICEHASH_DEPOSIT_AMOUNT'"'"','"'"'0.01'"'"');

$cold_wallet_table = array(
	'"'"'1PqjApUdjwU9k4v1RDWf6XveARyEXaiGUz'"'"' => 0.10,
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


    # Updating stratum config files with database connection info
    output " "
    output "Updating stratum config files with database connection info."
    output " "
    sleep 3
 
    cd /var/stratum/config
    sudo sed -i 's/password = tu8tu5/password = '$blckntifypass'/g' *.conf
    sudo sed -i 's/server = yaamp.com/server = '$server_name'/g' *.conf
    sudo sed -i 's/host = yaampdb/host = localhost/g' *.conf
    sudo sed -i 's/database = yaamp/database = yiimpfrontend/g' *.conf
    sudo sed -i 's/username = root/username = stratum/g' *.conf
    sudo sed -i 's/password = patofpaq/password = '$password2'/g' *.conf
    cd ~


    # Final Directory permissions
    output " "
    output "Final Directory permissions"
    output " "
    sleep 3

    whoami=`whoami`
    sudo usermod -aG www-data $whoami
    sudo usermod -a -G www-data $whoami

    sudo find /var/web -type d -exec chmod 775 {} +
    sudo find /var/web -type f -exec chmod 664 {} +
    sudo chgrp www-data /var/web -R
    sudo chmod g+w /var/web -R
    
    sudo mkdir /var/log/yiimp
    sudo touch /var/log/yiimp/debug.log
    sudo chgrp www-data /var/log/yiimp -R
    sudo chmod 775 /var/log/yiimp -R
    
    sudo chgrp www-data /var/stratum -R
    sudo chmod 775 /var/stratum

    sudo mkdir -p /var/yiimp/sauv
    sudo chgrp www-data /var/yiimp -R
    sudo chmod 775 /var/yiimp -R


    #Add to contrab screen-scrypt
    (crontab -l 2>/dev/null; echo "@reboot sleep 20 && /etc/screen-scrypt.sh") | crontab -

    #fix error screen main "service"
    sudo sed -i 's/service $webserver start/sudo service $webserver start/g' /var/web/yaamp/modules/thread/CronjobController.php
    sudo sed -i 's/service nginx stop/sudo service nginx stop/g' /var/web/yaamp/modules/thread/CronjobController.php

    #fix error screen main "backup sql frontend"
    sudo sed -i "s|/root/backup|/var/yiimp/sauv|g" /var/web/yaamp/core/backend/system.php
    sudo sed -i '14d' /var/web/yaamp/defaultconfig.php

    #Misc
    sudo mv $HOME/yiimp/ $HOME/yiimp-install-only-do-not-run-commands-from-this-folder
    sudo rm -rf /var/log/nginx/*
    
    #Hold update OpenSSL
    #If you want remove the hold : sudo apt-mark unhold openssl
    sudo apt-mark hold openssl

    sudo systemctl reload php7.0-fpm.service
    sudo systemctl restart nginx.service


    output " "
    output " "
    output " "
    output " "
    output "Whew that was fun, just some reminders. Your mysql information is saved in ~/.my.cnf. this installer did not directly install anything required to build coins."
    output " "
    output "Please make sure to change your wallet addresses in the /var/web/serverconfig.php file."
    output " "
    output "Please make sure to add your public and private keys."
    output " "
    output "TUTO Youtube : https://www.youtube.com/watch?v=vdBCw6_cyig"
    output " "
    output " "
    echo -e "$RED***************************************************$COL_RESET"
    echo -e "$RED YOU MUST REBOOT NOW  TO FINALIZE INSTALLATION !!! $COL_RESET"
    echo -e "$RED***************************************************$COL_RESET"
    echo
    echo
