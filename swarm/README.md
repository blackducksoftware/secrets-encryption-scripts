# Use of sample Docker Swarm scripts

#### Notes:

In Docker Swarm secrets defined need to be present and non-empty for an application
to launch if defined in a docker-compose.yaml file. Each service needs to have secrets
section:
```
services:
  authentication: 
    secrets:
      - crypto-root-seed
      - crypto-prev-seed
      - crypto-backup-seed
```     
There also needs to be a separate secrets section:

```
secrets:
  crypto-root-seed:
    external:
      true
  crypto-prev-seed:
    external:
      true
  crypto-backup-seed:
    external:
      true
```
The crypto library for Swarm treats secrets that are 1-2 bytes long as not present,
so when "deleting" a secret we just put a single byte in the secret.

<p>All the scripts, except extractRootAsPreviousSeed.sh, must be run when the Swarm is
not running. After running these scripts, the Swarm would then be (re-)deployed.

## createInitialSeeds.sh

This script should be run first, before enabling secrets encryption. It creates the root 
seed, the backup seed. The files containing the seeds are called, root_seed and backup_seed, respectively.

<p>After running the script these two files <b>should</b> be saved in a private to DevOps
secured location.

## extractRootAsPreviousSeed.sh

There is no docker command that will directly get the contents of a Swarm
secret (unlike Kubernetes). You can extract the seed, when the Swarm cluster is
running by using docker exec and cat-ing the root seed to a file.

## rotateRootSeed.sh

This script should be run when you want to rotate the root seed (as a previous rot seed). It takes
the name of the previous seed and creates a new root seed. The saved, previous
seed could just be renamed to some name like prev_seed.

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
