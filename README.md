# glacier-archive

Archive files in a directory (added since last execution) to AWS Glacier.

# Usage

1. Install the awscli and run `aws configure` to configure it with access keys that have proper access.
2. Using the AWS Console, create a Vault in Glacier
3. `/path/to/glacier-archive.sh my-vault-name /path/to/backup-data`
4. Schedule via cron if desired
