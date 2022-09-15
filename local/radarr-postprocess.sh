#!/bin/bash

[[ $radarr_eventtype == "Test" ]] && exit 0

# removes the movie file
[[ -e "$radarr_moviefile_sourcepath" ]] && rm "$radarr_moviefile_sourcepath"

# removes the directory, if the directory is not named *radarr*
# and it is empty
if [[ "$radarr_moviefile_sourcefolder" =~ "radarr" ]]; then
    exit 0
elif
    [[ -z $(ls -A "$radarr_moviefile_sourcefolder") ]]; then
        rm -r "$radarr_moviefile_sourcefolder"
fi

exit 0