# Use of sample Kubernetes scripts

### Notes:

All scripts take the Kubernetes namespace as an argument.

## createInitialSeeds.sh

This script should be run first, before enabling secrets encryption. It creates the root 
seed, the backup seed. The files containing the seeds are called, root_seed and backup_seed, respectively.

<p>After running the script these two files <b>should</b> be saved in a private to DevOps
secured location.

## cryptoStatus.sh

This script shows the current status of seeds and rotation.

## rotateRootSeed.sh

This script should be run when you want to rotate the root seed (as a previous rot seed).

## cleanupPreviousSeed.sh

This script <i>deletes</i> the previous root seed after the root seed is rotated.

## rotateBackupSeed.sh

This scripts rotates the backup seed, analogously to rotateRootSeed.sh.

## cleanupBackupSeed.sh

This script <i>deletes</i> the backup seed. This would be an unsafe operation
as if the root seed is lost, there is no way to access secrets.

## useRootSeed.sh

Instead of using createInitialSeeds.sh to create the root seed, you could use
a previously created seed.
