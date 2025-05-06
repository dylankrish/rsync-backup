#!/bin/bash

# directory to back up
DIR=""

# name of backup
BACKUP_NAME="backup"

# timestamp for folder name
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# remote backup server config
REMOTE_USER="backupuser"
REMOTE_HOST="backupserver.local"
REMOTE_DIR="/mnt/backups/$(hostname)/"

set -x # verbose
set -e

ARCHIVE_NAME="$BACKUP_NAME-$TIMESTAMP.tar.gz"

# compress directory for backup
echo "Compressing $DIR into $ARCHIVE_NAME..."
tar -czf "$ARCHIVE_NAME" "$DIR"

echo "Syncing to remote server..."
rsync -avz -e ssh "$ARCHIVE_NAME" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

echo "Cleaning up..."
rm "$ARCHIVE_NAME"