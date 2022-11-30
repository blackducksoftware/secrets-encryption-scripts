#!/bin/sh

##
## This script creates the initial root and backup seeds for a new deployment. Strictly speaking, the backup seed does
## not need to be created as it is optional - but this is the best time to configure it.
##
## Once the system comes up and everything is processed and working, the "cleanupBackupSecret.sh" script can be used to
## remove the backup secret from active use. The root and backup seed files needs to be securely stored in order to be
#@ able to recover this system from backup - the same seed(s) would need to be provided.
##

if [ $# -eq 0 ]; then
    echo "usage: $0 NAMESPACE"
    exit 1
fi

NAMESPACE=$1

echo "Using namespace $NAMESPACE"
echo "Generating root and backup seeds"

openssl rand -hex 1024 > root_seed
openssl rand -hex 1024 > backup_seed

echo "Creating secrets from seeds"
kubectl create secret generic crypto-root-seed -n $NAMESPACE --save-config --dry-run=client --from-file=crypto-root-seed=./root_seed -o yaml | kubectl apply -f -
kubectl create secret generic crypto-backup-seed -n $NAMESPACE --save-config --dry-run=client --from-file=crypto-backup-seed=./backup_seed -o yaml | kubectl apply -f -

echo "#############################"
echo "# PLEASE SECURE THESE FILES #"
echo "#############################"
echo "Copy the following files to a secure"
echo "location and delete them from this system"
echo ""
echo "root_seed   -- this file is the core secret stored in k8s"
echo "backup_seed -- this file is the backup secret that can become the root seed if needed"
echo ""
