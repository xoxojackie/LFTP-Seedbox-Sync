#!/bin/bash

# removes the episode file
[[ -e $sonarr_episodefile_sourcepath ]] && rm $sonarr_episodefile_sourcepath

# removes the directory, if the directory is not named *Sonarr*
if [[ $sonarr_episodefile_sourcefolder =~ "sonarr" ]]
    exit 0
else
    rm $sonarr_episodefile_sourcefolder
fi