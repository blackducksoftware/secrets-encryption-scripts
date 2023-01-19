#!/bin/sh

##
## This script allows you to import a file as the new root seed. This script should be used when restoring from backup
## and you need to set the root seed from the backed up seed, or optionally the backup seed can be used to recover a
## system whose root seed was lost or leaked
##

FILENAME=${1:-""}

if [ ! -f "$FILENAME" ]; then
    echo "New root seed file, $FILENAME, must exist"
    exit 1
fi

echo "Importing the file, $FILENAME, as the root seed"

docker secret rm crypto-root-seed > /dev/null
docker secret create crypto-root-seed $FILENAME > /dev/null
