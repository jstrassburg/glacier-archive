# glacier-archive

Archive files in a directory (added since last execution) to AWS Glacier.

# Usage

1. Install the awscli and run `aws configure` to configure it with access keys that have proper access.
2. Using the AWS Console, create a Vault in Glacier
3. `/path/to/glacier-archive.sh my-vault-name /path/to/backup-data`
4. Schedule via cron if desired

# Manage Archives

## List Archives

`aws glacier initiate-job --account-id - --vault-name my-vault --job-parameters '{"Type": "inventory-retrieval", "SNSTopic": "arn:aws:sns:region:acct-number:topic-name"}'`

That will output a jobId. Get job status with:

`aws glacier list-jobs --account-id - --vault-name my-vault`

Once complete:

`aws glacier get-job-output --account-id - --job-id $JOB_ID -`
