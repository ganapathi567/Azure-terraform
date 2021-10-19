#!/bin/bash


${appdynamics_installation_file_content}
#${splunk_installation_file_content}

# Install Azure cli
sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

#sudo az login --service-principal --username 'ebcd994b-5670-41c1-86b3-b9eba79b83ab' --password '8D#R4WjlqlH!eOCD' --tenant 'f55b1f7d-7a7f-49e4-9b90-55218aad89f8'
#sudo az account set --subscription "025-DEV-APP-1"
#sudo az login --identity

#sudo touch /etc/apt/sources.list.d/mongodb-org-4.2.repo
#sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.repo <<EOT
#${repo_file_content}
#EOT

# Downloading mount.sh file from storge blob
#sudo az storage blob download --account-name eundev025stsmongo --container-name dev-sts-mongo-uk --name mount.sh --file /home/azuresuer/mount.sh --auth-mode login

sudo mv /etc/security/limits.conf /etc/security/limits.conf-old
sudo touch /etc/security/limits.conf
sudo tee /etc/security/limits.conf <<EOT
${ulimit_content}
EOT

sudo touch /home/${admin_username}/mount.sh
sudo tee /home/${admin_username}/mount.sh <<EOT
${mount_disk_file_content}
EOT
sudo sh /home/${admin_username}/mount.sh 

sudo apt-get install gnupg
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -

touch /etc/apt/sources.list.d/mongodb-org-4.2.list
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
sudo apt-get update -y
sudo apt-get install -y mongodb-org=4.2.7 mongodb-org-server=4.2.7 mongodb-org-shell=4.2.7 mongodb-org-mongos=4.2.7 mongodb-org-tools=4.2.7

echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-org-shell hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

#sudo touch ${key_file}
#sudo tee ${key_file} <<EOT
#${key_file_content}
#EOT
#sudo chmod 400 ${key_file}
#sudo chown mongodb:mongodb ${key_file}

sudo tee /etc/mongod.conf <<EOT
${conf_file_content}
EOT

#mkdir -p /data/lib/mongo
#sudo chmod -R 700 /data/lib/mongo
#sudo chown -R mongodb:mongodb /data/lib/mongo
#sudo chcon -R --reference=/var/lib/mongodb /data/lib/mongo

sudo apt-get install firewalld -y
sudo firewall-cmd --zone=public --add-port=27017/tcp --permanent
sudo firewall-cmd --reload

sudo systemctl daemon-reload
sudo systemctl restart mongod
sudo systemctl enable mongod

${backup_scheduler_file_content}

sudo touch /home/${admin_username}/replica-set-init.js
sudo tee /home/${admin_username}/replica-set-init.js <<EOT
${replica_set_init_file_content}
EOT
#sudo mongo /home/${admin_username}/replica-set-init.js

sleep 30

sudo touch /home/${admin_username}/admin-user-init.js
sudo tee /home/${admin_username}/admin-user-init.js <<EOT
${admin_init_file_content}
EOT
#sudo mongo /home/${admin_username}/admin-user-init.js

#sudo su 
#hostname=$(sudo hostname | cut -d "-" -f 5-8) <<EOT
#echo "hostname is $hostname"
#mongoHostName="$hostname.zone.sts.dev.eun.azure.tesco.org"
#echo $mongoHostName > /etc/hostname
#hostname -F /etc/hostname
##bash -c 'echo $mongoHostName > /etc/hostname && hostname -F /etc/hostname'
#
#output=`dig $mongoHostName`
#while ! [[ $output =~ .*(ANSWER SECTION).* ]]; do
#  echo "sleeping for 2 seconds"
#  sleep 2
#  output=`dig $mongoHostName`
#done
#mongo --host $mongoHostName --eval "print(\"waited for connection\")"
#sleep 60
#mongo --host $mongoHostName /home/${admin_username}/replica-set-init.js
#
#EOT

#  lifecycle {
#    create_before_destroy = true
#  }
