#!/bin/sh

##
## Extract root seed into previous seed file in running swarm stack
##

if [ $# -eq 0 ]; then
    echo "usage: $0 STACK [PREVIOUS]"
    exit 1
fi

STACK=$1

PREVIOUS=${2:-./prev_seed}

if [ -f $PREVIOUS ]; then
    echo "$PREVIOUS file exists"
    exit 1
fi

echo "Extracting the root seed to a new previous seed, $PREVIOUS file"
# Extract the current root seed as the previous seed
docker exec blackduck_webapp.1.$(docker stack ps -q -f name=blackduck_webapp.1 $STACK) cat /run/secrets/crypto-root-secret > $PREVIOUS
