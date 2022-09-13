#!/bin/bash

##############################################################
# SEE THE README FOR IMPORTANT INSTRUCTIONS
# BEFORE SETTING THESE OPTIONS:
outgoing_dir="$HOME/outgoing"
labels_to_process=("sonarr" "sonarr-4k" "radarr" "radarr-4k" "sync")
tmp_dir_labels=("sonarr" "sonarr-4k")
label_conf_location="$HOME/.config/deluge/label.conf"
##############################################################

set -x

torrent_id=$1
torrent_name=$2
torrent_path=$3

torrent=$torrent_path/$torrent_name

get-label () {
    label=$(grep $torrent_id $label_conf_location | awk -F '"' '{print $4}')
}

check-label () {
    if printf '%s\n' "${labels_to_process[@]}" | grep -q -P ^$label$; then
        link_torrent="true"
    else
        link_torrent="false"
    fi
}

set-link-dir () {
    link_dir=${label^}
    if printf '%s\n' "${tmp_dir_labels[@]}" | grep -q -P ^$label$; then
        if [[ -d $torrent ]]; then
            link_dir=$link_dir-tmp
        fi
    fi
}

make-the-links () {
    mkdir -p "$outgoing_dir/$link_dir"
    if [[ -d $torrent ]]; then
        cp -rl "$torrent" "$outgoing_dir/$link_dir"
    else
        ln "$torrent" "$outgoing_dir/$link_dir"
    fi
}

get-label
check-label
[[ $link_torrent == "false" ]] && exit 125
set-link-dir
make-the-links
exit 0