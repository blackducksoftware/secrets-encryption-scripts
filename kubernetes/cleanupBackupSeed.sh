#!/bin/sh

##
## This script removes the backup seed from kubernetes secrets. Once present and processed by the system, the backup
## seed is stored and maintained internally. It is not recommended to run with a backup seed configured long term as
## it exposes the seed to the same security posture as the root seed (and they are interchangeable). A backup seed
## should be stored in a separate safe place so that it can be quickly swapped in the event the root seed is leaked
## or lost, while a key and data rotation is in progress
##

if [ $# -eq 0 ]; then
    echo "usage: $0 NAMESPACE"
    exit 1
fi

NAMESPACE=$1

echo "Using namespace $NAMESPACE"
echo "Cleaning up backup seed"
# Extract the backup seed to ensure a copy can be saved in a safe place
kubectl get secret crypto-backup-seed -n $NAMESPACE -o jsonpath='{.data}' | jq -r '.["crypto-backup-seed"]' | base64 -d > backup_seed
# Remove the back secret from k8s
kubectl delete secret crypto-backup-seed -n $NAMESPACE
echo "#############################"
echo "# PLEASE SECURE THESE FILES #"
echo "#############################"
echo "Copy the following files to a secure"
echo "location and delete them from this system"
echo ""
echo "backup_seed -- this file is the backup secret that can become the root seed if needed"
echo ""
