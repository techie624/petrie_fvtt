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

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
### vars

TAG=$(date +"%Y%m%d_%H%M%S")

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
### docker container and image cleanup

docker rm -f fvtt-node && docker image rm fvtt-node || true;
# docker rm -f $(docker ps -qa)  || true;
# docker image rm $(docker images)  || true;
# docker volume rm $(docker volume ls)  || true;
# docker network rm $(docker network ls)  || true;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
### Creating and adding the network for container internal communication
# docker network create dnd_net || true;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
### build image

export DOCKER_BUILDKIT=1
export DOCKER_CLI_BUILDKIT=1
time docker image build -t fvtt-node:$TAG .

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

# docker run -dti \
# --name fvtt-node \
# --hostname fvtt-node \
# --volume /media/rpetrie/storage/dnd/fvtt/fvtt_data:/root/foundrydata \
# --publish 80:30000/tcp \
# --restart=unless-stopped \
# --network=dnd_net \
# fvtt-node:$TAG

# docker run -dti \
# --name fvtt-node \
# --hostname fvtt-node \
# --volume /media/rpetrie/storage/dnd/fvtt/fvtt_data:/root/foundrydata \
# --publish 30000:30000/tcp \
# --publish 80:80/tcp \
# --publish 443:443/tcp \
# --restart=unless-stopped \
# --network=dnd_net \
# fvtt-node:$TAG

# docker run -dti \
# --name fvtt-node \
# --hostname fvtt-node \
# --volume /media/storage/dnd/fvtt/fvtt_data:/root/foundrydata \
# --publish 80:80/tcp \
# --publish 443:443/tcp \
# fvtt-node:$TAG

docker run -dti \
--name fvtt-node \
--hostname fvtt-node \
--publish 80:30000/tcp \
--publish 443:443/tcp \
fvtt-node:$TAG


sleep 5

docker exec -i -u root fvtt-node /bin/bash -c "service nginx start"

sleep 3

docker exec -i -u root fvtt-node /bin/bash -c "service nginx status"

# # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ### docker login

# set +x
#  docker login -u $DOCKER_LOGIN_USERNAME -p $DOCKER_LOGIN_PASS
# set -x

# # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ### create and push docker image

# docker tag fvtt-node:$TAG techie624/fvtt:$TAG

# docker tag fvtt-node:$TAG techie624/fvtt:latest

#docker push techie624/fvtt:$TAG

#docker push techie624/fvtt:latest

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
### 


#INDEX_TEST="Foundry Virtual Tabletop"
#wget localhost
#cat -r 5 index.html | cut -d ">" -f2 | cut -d "&" -f1