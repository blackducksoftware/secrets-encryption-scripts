#!/bin/sh

##
## This script removes the previous seed from swarm secrets. When a root key rotation is in process, the "current" seed is
## presented as the previous seed, and a new root seed is given as the "current" seed. This configuration allows
## systems that are running to fall back to the previous seed while root rotation is propagating and processing so
## operations can continue without error.
##
## After a period of time (operation must determine appropriate time - say 1 hour), the previous root seed can be removed
## with this script. Once removed, all keys encrypted by that seed are also removed completing the rotation.
## NOTE: Root key rotation does not affect data operations as the same key used for data encrypt/decrypt is made available
## encrypted by both the current and previous key
##

echo "Cleaning up previous seed"
docker secret rm crypto-prev-seed > /dev/null
echo -n "1" | ( docker secret create crypto-prev-seed - > /dev/null )

echo "#############################"
echo "# PLEASE SECURE THESE FILES #"
echo "#############################"
echo "Copy the following files to a secure"
echo "location and delete them from this system"
echo ""
echo "prev_seed -- this file is the previous root secret"
echo ""
