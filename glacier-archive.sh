#!/usr/bin/env bash

usage() {
    echo "Usage: $0 glacier-vault-name /path/to/dir"
    exit -1
}

if [ "$#" -lt 2 ]; then
    usage
fi

CURRENT_DATE=$(date +%Y%m%d)
GLACIER_VAULT=$1
BACKUP_DIR=$2
BACKUP_FILE=$BACKUP_DIR/$CURRENT_DATE-backup.tgz
LAST_BACKUP=$BACKUP_DIR/last-backup

if [ ! -f $LAST_BACKUP ]; then
  touch -d 19000101 $LAST_BACKUP
fi

echo "Backing up new files in $BACKUP_DIR to $GLACIER_VAULT..."
echo "Creating tarball $BACKUP_FILE..."

find $BACKUP_DIR -newer $LAST_BACKUP -not -path $BACKUP_DIR | xargs tar cfvz $BACKUP_FILE

if [ $? -eq 0 ]; then
    echo "Uploading $BACKUP_FILE to AWS Glacier..."
    aws glacier upload-archive --account-id - --vault-name $GLACIER_VAULT --body $BACKUP_FILE
    rm -f $BACKUP_FILE
else
    echo "No new files, skipping upload to AWS Glacier..."
fi

touch $LAST_BACKUP
