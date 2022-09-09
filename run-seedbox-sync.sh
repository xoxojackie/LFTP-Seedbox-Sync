#!/bin/bash

##############################################################
# SEE THE README FOR IMPORTANT INSTRUCTIONS
# BEFORE SETTING THESE OPTIONS:
incoming_dir="$HOME/Incoming"
lftp_conf_location="lftp.conf"
##############################################################

set -x

create-lock-file () {
    lockfile="/tmp/lftp-sb-sync.lock"
    if [[ -e "lockfile" ]]; then
        echo "run-seedbox-sync is already running! Exiting!"
        exit 1
    else
        touch "$lockfile"
    fi
}


create-lock-file