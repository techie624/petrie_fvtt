#!/usr/bin/env bash

set -e # Abort script at first error, when a command exits with non-zero status
set -u # Attempt to use undefined variable outputs error message, and forces 
# an exit
set -x # xtrace: Similar to -v, but expands commands [to unset and hide 
# passwords us "set +x"]

# set -v # sets verbosity to high echoing commands before executing

#-----------------------------------------------------------------------------#

#@author: RLPetrie (techie624@gmail.com)

#-----------------------------------------------------------------------------#
### Creating gdm docker network
#-----------------------------------------------------------------------------#

# Creating and adding the gobii docker network for container internal 
# communication
docker network create dnd_net || true;

docker run -dti \
--name fvtt-node \
--hostname fvtt-node \
-p 30000:30000 \
--restart=always \
--network=dnd_net \
techie624/fvtt:v0.1_20200617_1805

#test