#!/bin/sh

##
## This script is an example of how a root seed can be rotated while the system is online and operating without service disruption
##
## This script stores a passed in file as a previous seed. It then generates a new root seed and configures that.
##
## The new root seed file needs to be securely stored so that the system can be restored from backup with the correct root
## seed
##
## After this script is executed and the swarm stack is stopped,  "cleanupPreviousSecret.sh" needs to be run to remove
## the previous seed and complete the rotation
##

PREVIOUS=${1:-./prev_seed}
 
if [ ! -f ""$PREVIOUS"" ]; then
    echo "Previous seed file, $PREVIOUS, must exist"
    exit 1
fi

openssl rand -hex 1024 > root_seed

echo "Adding the previous seed to secrets"
docker secret rm crypto-prev-seed 2>&1 > /dev/null
docker secret create crypto-prev-seed $PREVIOUS > /dev/null

echo "Updating root seed with new version of seed"
docker secret rm crypto-root-seed > /dev/null
docker secret create crypto-root-seed ./root_seed > /dev/null

echo ""
echo "#############################"
echo "# PLEASE SECURE THESE FILES #"
echo "#############################"
echo "Copy the following files to a secure"
echo "location and delete them from this system"
echo ""
echo "root_seed   -- this file is the NEW core secret stored in k8s"
echo "$PREVIOUS   -- this file is the PREVIOUS core secret"
echo ""
