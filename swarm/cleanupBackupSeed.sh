#!/bin/sh

##
## This script removes the backup seed from swarm secrets. Once present and processed by the system, the backup seed is
## stored and maintained internally. It is not recommended to run with a backup seed configured long term as it exposes
## the seed to the same security posture as the root seed (and they are interchangeable). A backup seed should be stored
## in a separate safe place so that it can be quickly swapped in the event the root seed is leaked or lost, while a key
## and data rotation is in progress
##

echo "Cleaning up backup seed"
docker secret rm crypto-backup-seed > /dev/null
echo -n "1" | ( docker secret create crypto-backup-seed - > /dev/null )

echo "#############################"
echo "# PLEASE SECURE THESE FILES #"
echo "#############################"
echo "Copy the following files to a secure"
echo "location and delete them from this system"
echo ""
echo "backup_seed -- this file is the backup secret that can become the root seed if needed"
echo ""
