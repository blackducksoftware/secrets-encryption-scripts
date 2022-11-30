#!/bin/sh

##
## This script creates the initial root and backup seeds for a new deployment. Strictly speaking, the backup seed does
## not need to be created as it is optional - but this is the best time to configure it.
##
## Once the system comes up and everything is processed and working, the "cleanupBackupSecret.sh" script can be used
## to remove the backup secret from active use. The root and backup seed files needs to be securely stored n order to
## be able to recover this system from backup - the same seed(s) would need to be provided.
##

echo "Generating root and backup seeds"

openssl rand -hex 1024 > root_seed
openssl rand -hex 1024 > backup_seed

echo "Creating secrets from seeds"
docker secret create crypto-root-seed ./root_seed > /dev/null
docker secret create crypto-backup-seed ./backup_seed > /dev/null
echo -n "1" | ( docker secret create crypto-prev-seed - > /dev/null )

echo "#############################"
echo "# PLEASE SECURE THESE FILES #"
echo "#############################"
echo "Copy the following files to a secure"
echo "location and delete them from this system"
echo ""
echo "root_seed   -- this file is the core secret stored in docker swarm"
echo "backup_seed -- this file is the backup secret that can become the root seed if needed"
echo ""
