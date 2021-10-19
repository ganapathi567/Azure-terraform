#!/bin/bash

sudo yum update -y
# Install Azure cli
#sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
#sudo curl -sL https://aka.ms/InstallAzureCli | sudo bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

sudo touch /etc/yum.repos.d/azure-cli.sh
sudo tee /etc/yum.repos.d/azure-cli.sh <<EOT
${azure_cli_file_content}
EOT

# install dnf 
sudo yum install epel-release -y
sudo yum install dnf -y

sudo dnf install azure-cli

# install JAVA 8
sudo su
sudo yum  -y install java-1.8.0-openjdk wget

sudo touch /etc/profile.d/java-setup.sh
tee /etc/profile.d/java-setup.sh <<EOT
${java_setup_content}
EOT

source /etc/profile.d/java-setup.sh

sleep 30

sudo touch /home/${admin_username}/mount.sh
sudo tee /home/${admin_username}/mount.sh <<EOT
${mount_disk_file_content}
EOT
sudo sh mount.sh
