#!/bin/sh

##
## This script allows you to add a backup seed to a system that does not currently have one, or to change the backup seed
## to a new one, if the need arises
##
## Once this script executes and is processed by the system, call "cleanupBackupSecret.sh" to remove the backup secret from
## active use.
##
## The backup seed file produced by this script needs to be securely stored. After this operation and old backup seed that
## was configured is no longer useful.
##

if [ $# -eq 0 ]; then
    echo "usage: $0 NAMESPACE"
    exit 1
fi

NAMESPACE=$1

echo "Using namespace $NAMESPACE"
echo "Rotating the backup seed"
# Generate a new backup seed
openssl rand -hex 1024 > backup_seed

echo "Updating backup seed with new version of seed"
kubectl create secret generic crypto-backup-seed -n $NAMESPACE --save-config --dry-run=client --from-file=crypto-backup-seed=./backup_seed -o yaml | kubectl apply -f -

echo "#############################"
echo "# PLEASE SECURE THESE FILES #"
echo "#############################"
echo "Copy the following files to a secure"
echo "location and delete them from this system"
echo ""
echo "backup_seed -- this file is the backup secret that can become the root seed if needed"
echo ""
