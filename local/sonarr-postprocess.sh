#!/bin/bash

[[ $sonarr_eventtype == "Test" ]] && exit 0

# removes the episode file
[[ -e "$sonarr_episodefile_sourcepath" ]] && rm "$sonarr_episodefile_sourcepath"

# removes the directory, if the directory is not named *Sonarr*
# and it is empty
if [[ "$sonarr_episodefile_sourcefolder" =~ "Sonarr" ]]; then
    exit 0
elif
    [[ -z $(ls -A "$sonarr_episodefile_sourcefolder") ]]; then
        rm -r "$sonarr_episodefile_sourcefolder"
fi

exit 0