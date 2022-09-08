#!/usr/bin/env bash

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
set -e # Abort script at first error, when a command exits with non-zero status
set -u # Attempt to use undefined variable outputs error message, and forces 
# an exit
set -x # xtrace: Similar to -v, but expands commands [to unset and hide 
# passwords us "set +x"]
# set -v # sets verbosity to high echoing commands before executing

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
#@author: RLPetrie (techie624@gmail.com)

docker rm -f fvtt-node && docker image rm fvtt-node || true;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

docker run -dti \
--name fvtt-node \
--hostname fvtt-node \
--publish 80:80/tcp \
--publish 443:443/tcp \
--restart=always \
techie624/fvtt:latest


sleep 5

docker exec -i -u root fvtt-node /bin/bash -c "service nginx start"

sleep 3

docker exec -i -u root fvtt-node /bin/bash -c "service nginx status"
