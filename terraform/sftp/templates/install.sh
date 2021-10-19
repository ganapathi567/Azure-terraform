#!/bin/bash
sudo su 
sudo yum update -y
# Install Azure cli
#sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
#sudo curl -sL https://aka.ms/InstallAzureCli | sudo bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

sudo touch /etc/yum.repos.d/azure-cli.sh
sudo tee /etc/yum.repos.d/azure-cli.sh <<EOT
${azure_cli_file_content}
EOT
sudo sh /etc/yum.repos.d/azure-cli.sh
# install dnf 
sudo yum install epel-release -y
sudo yum install dnf -y

sudo dnf install azure-cli -y

# login to azure rootsp
sudo az login --service-principal --username 'c075239a-ee64-4789-9e17-586658785a54' --password 'JVWlImX.jBP8C.Q#' --tenant 'f55b1f7d-7a7f-49e4-9b90-55218aad89f8'
sudo az account set --subscription "025-PROD-APP-1"
#sudo az login --identity

sudo su
#sudo yum update -y
sudo yum  -y install java-1.8.0-openjdk wget

sudo touch /etc/profile.d/java-setup.sh
tee /etc/profile.d/java-setup.sh <<EOT
${java_setup_content}
EOT

source /etc/profile.d/java-setup.sh

#sudo adduser --shell /bin/bash --no-create-home frs

sleep 30

sudo touch /home/${admin_username}/mount.sh
sudo tee /home/${admin_username}/mount.sh <<EOT
${mount_disk_file_content}
EOT
sudo sh mount.sh

#create SSh home dir in /home/frs user dir
sudo mkdir /home/frs/.ssh
sudo chown -R frs:frs /home/frs/.ssh
sudo chmod 755 /home/frs/.ssh
sudo touch /home/frs/.ssh/authorized.keys
sudo tee /home/${admin_username}/authorized.keys <<EOT
${authorized_keys_file_content}
EOT

##Disable swapiness
sudo echo 0  > /proc/sys/vm/swappiness

sudo mv /etc/ssh/sshd_config /etc/ssh/sshd_config_bkp
sudo touch /etc/ssh/sshd_config
sudo tee /home/${admin_username}/sshd_config <<EOT
${sshd_config_file_content}
EOT

#Restart SSH Service
sudo service sshd restart

# Set Cron Job
sudo touch /etc/${admin_username}/crontab_file
sudo tee /home/${admin_username}/crontab_file <<EOT
${crontab_file_file_content}
EOT

# install azcopy
sudo curl -L -JO https://azcopyvnext.azureedge.net/release20190703/azcopy_linux_amd64_10.2.1.tar.gz
sudo tar -xf azcopy_linux_amd64_10.2.1.tar.gz
cd azcopy_linux_amd64_10.2.1/
./azcopy login --service-principal  --application-id c075239a-ee64-4789-9e17-586658785a54 --tenant-id=f55b1f7d-7a7f-49e4-9b90-55218aad89f8

sudo crontab -u sts-admin /home/${admin_username}/crontab_file &

sudo yum install firewalld -y
systemctl status firewalld
systemctl restart firewalld
systemctl enable firewalld
#
firewall-cmd --zone=public --add-port=22/ssh --permanent
firewall-cmd --reload
#
#firewall-cmd --zone=public --add-port=9092/tcp --permanent
#firewall-cmd --reload

