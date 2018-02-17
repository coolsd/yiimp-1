#!/bin/bash
################################################################################
# Original Author: crombiecrunch
# Current Author: Xavatar
# Web:
#
# Program:
#   After entering coin name and github link automatically build coin
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
cd ~

if [[ ! -e 'CoinBuilds' ]]; then
        sudo mkdir CoinBuilds
elif [[ ! -d 'CoinBuilds' ]]; then
    output "Coinbuilds already exists.... Skipping" 1>&2
fi

clear
cd CoinBuilds
output "This script assumes you already have the dependicies installed on your system!"
output ""
    read -e -p "Enter the name of the coin : " coin
    read -e -p "Paste the github link for the coin : " git_hub

if [[ ! -e '$coin' ]]; then
    sudo  git clone $git_hub  $coin
elif [[ ! -d ~$CoinBuilds/$coin ]]; then
    output "Coinbuilds/$coin already exists.... Skipping" 1>&2
    output "Can not continue"
    exit 0
fi

cd "${coin}"

if [ -f autogen.sh ]; then
		output " "
        output "Auto Compilation Starting "
		output " "
		output "Starting ./autogen.sh"
		output " "
		sudo ./autogen.sh
		output " "
		output "Starting ./configure"
		output " "
        sudo ./configure
		output " "
		output "Starting make"
		output " "
        sudo make
		output " "
        output "$coin_name finished and can be found in CoinBuilds/$coin/src/ Make sure you sudo strip Coind and coin-cli if it exists, copy to /usr/bin"
		output " "
else
        cd src
if [[ ! -e 'obj' ]]; then
	output " "
	output "Creation directory obj"
	output " "
	sudo mkdir obj
elif [[ ! -d 'obj' ]]; then
    output "Hey the developer did his job" 1>&2
fi

if [ -d 'leveldb' ]; then
	output " "
	output "Compilation libleveldb.a libmemenv.a"
	output " "
	cd leveldb
	sudo chmod +x build_detect_platform
	sudo make clean
	sudo make libleveldb.a libmemenv.a
	cd ..
fi
output " "
output "SRC Compilation Starting "
output " "
sudo make -f makefile.unix
output " "
output "$coin finished and can be found in CoinBuilds/$coin/src/ Make sure you sudo strip Coind and coin-cli if it exists, copy to /usr/bin"
output " "
fi
