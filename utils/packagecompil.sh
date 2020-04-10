    
#!/bin/bash
################################################################################
# Original Author:   Xavatar (https://github.com/xavatar/yiimp_install_scrypt)
# Web: https://www.xavatar.com  
#
# Program:
#   Install needed Package to compile crypto currency
# 
# 
################################################################################
    
    # Installing Package to compile crypto currency
    output " "
    output "Installing needed Package to compile crypto currency"
    output " "
    sleep 3
    
    sudo apt -y install software-properties-common build-essential
    sudo apt -y install libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils git cmake libboost-all-dev zlib1g-dev libz-dev libseccomp-dev libcap-dev libminiupnpc-dev gettext
    sudo apt -y install libminiupnpc10 libzmq5
    sudo apt -y install libcanberra-gtk-module libqrencode-dev libzmq3-dev
    sudo apt -y install libqt5gui5 libqt5core5a libqt5webkit5-dev libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler
    sudo add-apt-repository -y ppa:bitcoin/bitcoin
    sudo apt -y update
    sudo apt install -y libdb4.8-dev libdb4.8++-dev libdb5.3 libdb5.3++
