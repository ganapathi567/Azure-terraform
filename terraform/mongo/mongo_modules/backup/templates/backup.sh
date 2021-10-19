#!/bin/bash

BACKUP_DIR=/mongodb/tmp/${service_name}-backup
BACKUP_FILE_NAME=backup

if [ -d "\$BACKUP_DIR" ]; then
  printf '%s\n' "Delete ${service_name} backup directory \$BACKUP_DIR"
  rm -rf "\$BACKUP_DIR"
fi

mkdir -p "\$BACKUP_DIR"
mkdir -p "${log_path}"

isActive=false
isSuccess=false

${service_backup_script}

logFile="${log_path}/backup.log"

if [ "\$isActive" == "true" ]
then
  printf '%s\n' "Active node found"
  if [ "\$isSuccess" == "true" ]
  then
    printf '%s %s\n' "Script reported success, start upload of backup file" "\$BACKUP_DIR/\$BACKUP_FILE"

    BACKUP_FILE="\$(date +%FT%H-%M-%S)-${service_name}-\$HOSTNAME-backup.tar.gz"

    tar -C "\$BACKUP_DIR" -zcvf "\$BACKUP_DIR/\$BACKUP_FILE" "\$BACKUP_FILE_NAME"

    #az login --identity
    az login --service-principal --username 'ebcd994b-5670-41c1-86b3-b9eba79b83ab' --password '8D#R4WjlqlH!eOCD' --tenant 'f55b1f7d-7a7f-49e4-9b90-55218aad89f8'
    az account set --subscription ${subscription_id}

    az storage blob upload --account-name ${storage_account} --container-name ${storage_container_name} --file "\$BACKUP_DIR/\$BACKUP_FILE" --name "\$BACKUP_FILE" --auth-mode login && isUploadComplete=true

    if [ "\$isUploadComplete" == "true" ]
    then
      echo "\$(date +%FT%H:%M:%S) \$HOSTNAME ${application_name} ${source_type} INFO  ${service_name} backup complete \$BACKUP_FILE" >> "\$logFile"
    else
      echo "\$(date +%FT%H:%M:%S) \$HOSTNAME ${application_name} ${source_type} ERROR ${service_name} backup failed \$BACKUP_FILE" >> "\$logFile"
    fi
  else
    printf '%s\n' "Script reported failure"
    echo "\$(date +%FT%H:%M:%S) \$HOSTNAME ${application_name} ${source_type} ERROR ${service_name} backup error \$BACKUP_FILE" >> "\$logFile"
  fi
else
  printf '%s\n' "Inactive node found"
  echo "\$(date +%FT%H:%M:%S) \$HOSTNAME ${application_name} ${source_type} INFO  ${service_name} backup inactive \$BACKUP_FILE" >> "\$logFile"
fi
