#!/bin/sh

##
## This script finds the "webapp" container running in the kubernetes namespace and executes a script on it allowing the
## crypto status to be displayed
##
## By default this displays in a human readable form - but if the "-json" arg is provided, the output is returned as json
## which is suitable for parsing by jq or other means
##

if [ $# -eq 0 ]; then
    echo "usage: $0 NAMESPACE [-json]"
    exit 1
fi

NAMESPACE=$1

if [ $# -eq 1 ]; then
  echo "Using namespace $NAMESPACE"
  echo "Current crypto status:"
fi
WEBAPP_POD=$(kubectl get pods --no-headers -o custom-columns=":metadata.name" -n $NAMESPACE | grep webapp-logstash)
kubectl exec $WEBAPP_POD -c webapp -n $NAMESPACE -- /opt/blackduck/hub/hub-webapp/bin/cryptostatus.sh $2
