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

move-tmp-dirs () {
    find "$incoming_dir" -name "*-tmp" | while read tmpdir; do
        non_tmpdir=${tmpdir::-4}
        mv "$tmpdir"/* $non_tmpdir
        [[ -z $(ls -A "$tmpdir") ]] && rm -r "$tmpdir"
    done
}

cleanup () {
    [[ -e "$lockfile" ]] && rm "$lockfile"
}

trap cleanup SIGINT SIGTERM

create-lock-file
move-tmp-dirs
cleanup