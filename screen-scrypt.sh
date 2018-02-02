#!/bin/bash
 LOG_DIR=/var/log
 WEB_DIR=/var/web
 STRATUM_DIR=/var/stratum
 USR_BIN=/usr/bin
 
 screen -dmS main bash $WEB_DIR/main.sh
 screen -dmS loop2 bash $WEB_DIR/loop2.sh
 screen -dmS blocks bash $WEB_DIR/blocks.sh
 screen -dmS debug tail -f $LOG_DIR/debug.log
 

 