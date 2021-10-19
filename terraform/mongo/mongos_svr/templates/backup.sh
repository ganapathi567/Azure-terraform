isActive=\$(mongo --quiet --eval "rs.isMaster()['ismaster']")

if [ "\$isActive" == "true" ]
then
  mongodump --username ${username} --password ${password} --out "\$BACKUP_DIR/\$BACKUP_FILE_NAME" && isSuccess=true
fi
