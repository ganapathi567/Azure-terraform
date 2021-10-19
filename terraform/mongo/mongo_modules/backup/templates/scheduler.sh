### Start backup schedule

mkdir -p /var/lib/${service_name}/backup
touch /var/lib/${service_name}/backup/backup.sh
tee /var/lib/${service_name}/backup/backup.sh <<EOT
${backup_script}
EOT

touch /etc/cron.d/${service_name}-backup
chmod 600 /etc/cron.d/${service_name}-backup
tee /etc/cron.d/${service_name}-backup <<EOT
0 1 * * * root /bin/bash /var/lib/${service_name}/backup/backup.sh
EOT
touch /etc/cron.d/${service_name}-backup

### End backup schedule
