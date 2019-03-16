#!/bin/bash
###############################################################################
# CONFIGURATION
###############################################################################
# shellcheck source=config

. "/usr/bin/config"
##############################################################################

plex_url=$(printenv PLEX_URL | tr -d '"' | tr -d "'")
plex_token=$(printenv PLEX_TOKEN | tr -d '"' | tr -d "'")

getSections() {
    if [ -z "${plex_url}" ]; then
        echo "Fill in plex url and plex token to retrieve sections. Aborting..."
        exit 02
    fi

    sections=$(curl -s -k -G -L "${plex_url}/library/sections?X-Plex-Token=${plex_token}" | sed -n 's/.*key="\([^"]*\).*/\1/p')
    echo $sections
}

isRefreshing() {
    refreshing=$(curl -s -k -G -L "${plex_url}/library/sections?X-Plex-Token=${plex_token}" | grep 'refreshing="1"')

    echo $refreshing
}

emptyTrash() {
    . "/usr/bin/check"

    if [ "$all_good" -eq "1" ]; then
        echo "Refreshing library"
        curl -s -k -G -L "${plex_url}/library/sections/all/refresh?X-Plex-Token=${plex_token}"
        
        echo "[ $(date ${date_format}) ] Library refreshing"
        while true; do
            sleep 10
            if [[ -z $(isRefreshing) ]]; then
                break
            fi
        done
        echo "[ $(date ${date_format}) ] Library refresh completed"
        
        sections=$(getSections)
        if [ -z "${sections}" ]; then
            echo "Could not get sections from ${plex_url} with the inserted token. Aborting..."
            exit 02
        fi

        for i in $sections
        do
            if [[ ! -z "${i}" ]]; then
                echo "Empty trash for section ${i}"
                curl -s -k -X PUT -L "${plex_url}/library/sections/${i}/emptyTrash?X-Plex-Token=${plex_token}"
            fi
        done

        exit 0
    else
        echo "Mount is not up after mountcheck. Aborting..."
        exit 02
    fi
}
    
emptyTrash
