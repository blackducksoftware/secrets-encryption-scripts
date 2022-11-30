#!/bin/sh

##
## This script is an example of how a root seed can be rotated while the system is online and operating without service disruption
##
## This script extracts the current root seed and configures it as a previous seed. It then generates a new root seed and
## configures that. It then monitors the crypto status until it sees the root seed in the system change
##
## The new root seed file needs to be securely stored so that the system can be restored from backup with the correct root seed
##
## After this script is executed, after a time has elapsed as determined by the operator (1 hour?), the "cleanupPreviousSeed.sh"
## needs to be run to remove the previous seed and complete the rotation
##

if [ $# -eq 0 ]; then
    echo "usage: $0 NAMESPACE"
    exit 1
fi

## This function extracts the current root seed id and returns it to the caller
function getActiveRootId() 
{
  ROOTID=$(./cryptoStatus.sh $NAMESPACE -json | jq -r '.[] | select ((.type == "ROOT") and (.state == "ACTIVE")).resource_id') 2>&1 >/dev/null
  if [ "$?" -ne "0" ]; then
     ROOTID=ERROR
  fi
  if [ -z "$ROOTID" ]; then
     ROOTID=ERROR
  fi
  echo $ROOTID
}

NAMESPACE=$1

echo "Using namespace $NAMESPACE"
OLDROOTID=$(getActiveRootId)
while [ "$OLDROOTID" == "ERROR" ]
do
   echo "Got error fetching current root seed id, pausing and then retrying"
   sleep 10
   OLDROOTID=$(getActiveRootId)
done
echo "Rotating the root seed from $OLDROOTID to a new root seed"
# Extract the current root seed as the previous seed
kubectl get secret crypto-root-seed -n $NAMESPACE -o jsonpath='{.data}' | jq -r '.["crypto-root-seed"]' | base64 -d > prev_seed
# Generate a new root seed
openssl rand -hex 1024 > root_seed

echo "Adding the previous seed to secrets"
kubectl create secret generic crypto-prev-seed -n $NAMESPACE --save-config --dry-run=client --from-file=crypto-prev-seed=./prev_seed -o yaml | kubectl apply -f -

##
## There may need to be a sleep here to allow the previous seed to propagate to the k8s nodes before the root seed is changed to ensure it is available
## order of operations and speed of secret propigation is unknown at this point
##

echo "Updating root seed with new version of seed"
kubectl create secret generic crypto-root-seed -n $NAMESPACE --save-config --dry-run=client --from-file=crypto-root-seed=./root_seed -o yaml | kubectl apply -f -

NEWROOTID=$(getActiveRootId)
while [ "$OLDROOTID" == "$NEWROOTID" ] || [ "$NEWROOTID" == "ERROR" ]
do
  if [ "$NEWROOTID" == "ERROR" ]; then
     echo "Error fetching current root id, retrying..."
  else 
     echo "Waiting for root id to change from $NEWROOTID"
     sleep 30
  fi
  NEWROOTID=$(getActiveRootId)
done

echo "New root secret id: $NEWROOTID"
echo ""
echo "#############################"
echo "# PLEASE SECURE THESE FILES #"
echo "#############################"
echo "Copy the following files to a secure"
echo "location and delete them from this system"
echo ""
echo "root_seed   -- this file is the NEW core secret stored in k8s"
echo "prev_seed   -- this file is the PREVIOUS core secret"
echo ""
