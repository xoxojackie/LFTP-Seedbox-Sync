#!/bin/bash

#########################################################################
# outgoing_dir is on the remote machine, incoming_dir is local
outgoing_dir="$HOME/outgoing"
incoming_dir="$HOME/Incoming"
#########################################################################

set -x

base_dir="$(dirname "$(readlink -f "$0")")"

create-lock-file () {
    lockfile="/tmp/lftp-sb-sync.lock"
    if [[ -e "lockfile" ]]; then
        echo "run-seedbox-sync is already running! Exiting!"
        exit 1
    else
        touch "$lockfile"
    fi
}

source-ftp-options () {
    if [[ -e $base_dir/ftp-options.conf ]]; then
        source "$base_dir/ftp-options.conf"
    else
        echo "ftp-options.conf missing! Exiting!"
        cleanup && exit 1
    fi
}

lftp-transfer () {
    lftp << EOF
    source lftp.conf
    connect -u "$ftp_user":"$ftp_pass" -p "$ftp_port" "$ftp_address"
    mirror -c -p -vvv --Move "$outgoing_dir"/ "$incoming_dir"/
    quit
EOF
}

move-tmp-dirs () {
    find "$incoming_dir" -name "*-tmp" | while read tmpdir; do
        non_tmpdir=${tmpdir::-4}
        mv "$tmpdir"/* "$non_tmpdir"
        [[ -z $(ls -A "$tmpdir") ]] && rm -r "$tmpdir"
    done
}

cleanup () {
    [[ -e "$lockfile" ]] && rm "$lockfile"
}

trap cleanup SIGINT SIGTERM

create-lock-file
source-ftp-options
lftp-transfer
move-tmp-dirs
cleanup