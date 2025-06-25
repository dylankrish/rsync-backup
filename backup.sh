#!/bin/bash

# directory to back up
DIR=""

# name of backup
BACKUP_NAME="backup"

# ssh key to use
SSH_KEY="~/.ssh/backup_rsync"
# remote backup server config
REMOTE_USER="backupuser"
REMOTE_HOST="backupserver.local"
REMOTE_DIR="/home/backupuser/backups/"


TIMESTAMP=$(date +"%Y%m%d_%H%M%S") # timestamp for folder name
ARCHIVE_NAME="$BACKUP_NAME-$TIMESTAMP.tar.gz"

set -e # exit on error
# set -x # verbose

# compress directory for backup
echo "Compressing $DIR into $ARCHIVE_NAME..."
tar -czf "$ARCHIVE_NAME" "$DIR"

echo "Syncing to remote server..."
rsync -avz -e "ssh -i $SSH_KEY" "$ARCHIVE_NAME" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

echo "Cleaning up..."
rm "$ARCHIVE_NAME"