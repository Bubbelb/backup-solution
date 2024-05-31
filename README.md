# Usecase

Main Goal:_ Create Borg Backups of a set of docker volumes. Nothing more (for now).
Backups should be done on a snapshotted, or equivalent environment.



## Prerequisites
1. Storage (where Docker files reside, /var/lib/docker):
    1. Highly recommend: a FS that can shapshot. (btrfs/zfs)
    2. Second option: a FS that can create reflinks (XFS)
    3. Third option: keep an rsync clone for backup. Not reccomended. 2x space usage.
2. A Docker container with --privileged access (we need to run docker inside)
3. An overview of the volumes to be in the backup
4. An exclusion list (Per volume?)
5. A backup schedule & options (borgmatic Yaml files?)

## Thoughts
* How to restore in a most convenient way?
* Can/should we use native borgmatic Database Backup options?
* Nice one: Get usage identical to Standard Borgmatic Container (With Cron support)

## Whole process - summary
* Container takes the whole Borgmatic Docker config, and thus aims to be an in-place addition to Borgmatic Container (Exception: --privileged flag).
* All the config mappings, except for the Cron wil be duplicated to the borgmatc container.
* At backup time:
    * Optionally stop running containers
    * All the subvolumes in the /var/lib/docker location will be snapshotted.
    * Optionally start stopped containers
    * The container registrations under the snapshotted /var/lib/docker will be removed (to prevent container start).
    * Nested Docker daemon will be started
    * Borgmatic docker container will be started with all volumes attached.
    * After backup, cleanup:
        * Nested Docker Daemon will be stopped
        * All snapshots under /var/lib/docker will be removed
        * Sleep until next backup event.

* All the (snapshotted) containers will be mounted under /mnt/volumes, under their own name.

## Backup Preparation process
1. Start a privileged container with options:
    1. bind-mount to host's /var/lib/docker path
    2. BTRFS tools installed
    3. Docker and tools installed

## Snapshot Options
