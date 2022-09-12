#!/bin/bash

##############################################################
# SEE THE README FOR IMPORTANT INSTRUCTIONS
# BEFORE SETTING THESE OPTIONS:
incoming_dir="$HOME/Incoming"
outgoing_dir="$HOME/Outgoing"
ftp_user="thewiz"
ftp_pass_file="ftp-pass.secret"
ftp_address="avalon-iv.xojackie.xyz"
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

get-ftp-pass () {
    ftp_pass=$(cat "$ftp_pass_file")
}

lftp-transfer () {
    lftp << EOF
    source lftp.conf
    connect -u "$ftp_user":"$ftp_pass" -p "$ftp_port" "$ftp_address"
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
get-ftp-pass
move-tmp-dirs
cleanup