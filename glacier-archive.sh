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
BACKUP_LOG=$BACKUP_DIR/glacier-archive.log

if [ ! -f $BACKUP_LOG ]; then
  touch -d 19000101 $BACKUP_LOG
fi

echo "Backing up new files in $BACKUP_DIR to $GLACIER_VAULT..."
echo "Creating tarball $BACKUP_FILE..."

find $BACKUP_DIR -newer $BACKUP_LOG -not -path $BACKUP_DIR | xargs tar cfvz $BACKUP_FILE

if [ $? -eq 0 ]; then
    echo "Uploading $BACKUP_FILE to AWS Glacier..."
    echo $CURRENT_DATE >> $BACKUP_LOG
    aws glacier upload-archive --account-id - --vault-name $GLACIER_VAULT --body $BACKUP_FILE | tee -a $BACKUP_LOG
    rm -f $BACKUP_FILE
else
    echo "No new files, skipping upload to AWS Glacier..."
fi
