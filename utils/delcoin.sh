#!/bin/bash
################################################################################
# Author: Xavatar (https://github.com/xavatar/yiimp_install_scrypt)
# Web: https://www.xavatar.com    
#
# Program:
#   Remove all coin in Yiimp
# 
# 
################################################################################

for line in $(cat coin.list); do
yiimp coin "$line" delete;
done
