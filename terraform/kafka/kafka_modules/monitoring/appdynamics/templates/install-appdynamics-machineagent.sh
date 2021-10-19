### Start AppDynamics installation

# Install Azure cli
sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

#az login --identity
sudo az login --service-principal --username 'ebcd994b-5670-41c1-86b3-b9eba79b83ab' --password '8D#R4WjlqlH!eOCD' --tenant 'f55b1f7d-7a7f-49e4-9b90-55218aad89f8'
sudo az account set --subscription "025-DEV-APP-1"

sudo az storage blob download --account-name ${storage_account} --container-name installers --name MachineAgent-21.3.0.3059.zip --file /tmp/MachineAgent-21.3.0.3059.zip
sudo az storage blob download --account-name ${storage_account} --container-name installers --name processmonitor-2.3.zip --file /tmp/processmonitor-2.3.zip 
sudo az storage blob download --account-name ${storage_account} --container-name installers --name diskspacealertextension-1.1.zip --file /tmp/diskspacealertextension-1.1.zip

# Make directory for AppDynamics machine agent
mkdir -p /opt/appdynamics/machineagent
chmod -R 755 /opt/appdynamics/machineagent

sudo yum install unzip -y

unzip -qqo /tmp/MachineAgent-21.3.0.3059.zip -d /opt/appdynamics/machineagent
rm /opt/appdynamics/machineagent/conf/controller-info.xml

touch /opt/appdynamics/machineagent/conf/controller-info.xml
tee /opt/appdynamics/machineagent/conf/controller-info.xml <<EOT
${controller_info_file_content}
EOT

echo "$HOSTNAME"
sed -i '' -e "s/__HOSTNAME__/$HOSTNAME/" /opt/appdynamics/machineagent/conf/controller-info.xml

unzip -qqo /tmp/processmonitor-2.3.zip -d /opt/appdynamics/machineagent/monitors/
rm /opt/appdynamics/machineagent/monitors/ProcessMonitor/config.yml

touch /opt/appdynamics/machineagent/monitors/ProcessMonitor/config.yml
tee /opt/appdynamics/machineagent/monitors/ProcessMonitor/config.yml <<EOT
${process_monitor_config_file_content}
EOT

touch /etc/systemd/system/appdynamics-machine-agent.service
tee /etc/systemd/system/appdynamics-machine-agent.service <<EOT
${machineagent_systemd_service_file_content}
EOT

systemctl enable appdynamics-machine-agent.service
systemctl start appdynamics-machine-agent.service

unzip -qqo /tmp/diskspacealertextension-1.1.zip -d /opt/appdynamics/machineagent/monitors/

systemctl restart appdynamics-machine-agent.service

### End AppDynamics installation
