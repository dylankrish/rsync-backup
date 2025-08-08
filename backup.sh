#!/bin/bash

DIR="" # directory to back up
BACKUP_NAME="backup" # name of backup
SSH_KEY="~/.ssh/backup_rsync" # ssh key to use
REMOTE_USER="backupuser" # user to log in as
REMOTE_HOST="backupserver.local" # hostname or IP address to connect to
REMOTE_DIR="/" # directory to back up to on the server, remember to add / to the end

TIMESTAMP=$(date +"%Y%m%d_%H%M%S") # timestamp for folder name
ARCHIVE_NAME="$BACKUP_NAME-$TIMESTAMP.tar.gz"

set -e # exit on error
# set -x # verbose

# add any pre-backup code here, such as temporarily stopping services to prevent file changes
# ---

# ---

# compress directory for backup
echo "Compressing $DIR into $ARCHIVE_NAME..."
tar -czf "$ARCHIVE_NAME" "$DIR"

# add any restore code here, such as restarting the services
# ---

# ---


echo "Syncing to remote server..."
rsync -avz -e "ssh -i $SSH_KEY" "$ARCHIVE_NAME" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

echo "Cleaning up..."
rm "$ARCHIVE_NAME"
