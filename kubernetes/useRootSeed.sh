#!/bin/sh

##
## This script allows you to import a file as the new root seed. This script should be used when restoring from backup and
## you need to set the root seed from the backed up seed, or optionally the backup seed can be used to recover a system
## whose root seed was lost or leaked
##

if [ $# -lt 2 ]; then
    echo "usage: $0 NAMESPACE FILENAME"
    exit 1
fi

NAMESPACE=$1
FILENAME=$2

echo "Using namespace $NAMESPACE"
echo "Importing the file as the root seed"

kubectl create secret generic crypto-root-seed -n $NAMESPACE --save-config --dry-run=client --from-file=crypto-root-seed=$FILENAME -o yaml | kubectl apply -f -

