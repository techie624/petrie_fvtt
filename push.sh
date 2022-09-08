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

TAG=$(docker ps --format "table {{.Names}}\t{{.Image}}" |grep fvtt |cut -d " " -f7 |cut -d ":" -f2)
IMAGE=$(docker ps --format "table {{.Names}}\t{{.Image}}" |grep fvtt |cut -d " " -f7)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
### 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
### docker login

set +x
 docker login -u $DOCKER_LOGIN_USERNAME -p $DOCKER_LOGIN_PASS
set -x

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
### create and push docker image

docker tag fvtt-node:$TAG techie624/fvtt:$TAG

docker tag fvtt-node:$TAG techie624/fvtt:latest

docker push techie624/fvtt:$TAG

docker push techie624/fvtt:latest

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
### clean up all docker images related to fvtt

docker rm -f fvtt-node:$TAG || true;

docker rmi -f fvtt-node:$TAG techie624/fvtt:$TAG techie624/fvtt:latest ||true;

#test