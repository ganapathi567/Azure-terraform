### Start Splunk installation

# Install packages
sudo curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
#sudo apt-add-repository https://packages.microsoft.com/ubuntu/18.04/prod

# Download installer package
sudo az login --service-principal --username 'ebcd994b-5670-41c1-86b3-b9eba79b83ab' --password '8D#R4WjlqlH!eOCD' --tenant 'f55b1f7d-7a7f-49e4-9b90-55218aad89f8'
sudo az account set --subscription 
#sudo az login --identity

az storage blob download --account-name ${storage_account} --container-name installers --name splunkforwarder-8.0.5-a1a6394cc5ae-Linux-x86_64.tgz --file /tmp/splunkforwarder-8.0.5-a1a6394cc5ae-Linux-x86_64.tgz --auth-mode login
az storage blob download --account-name ${storage_account} --container-name installers --name UF-cloud_tesco_config_operations-ssloutputs.tar.gz --file /tmp/UF-cloud_tesco_config_operations-ssloutputs.tar.gz --auth-mode login

# Make directory for Splunk forwarder
mkdir -p /opt/splunkforwarder
chmod -R 755 /opt/splunkforwarder

sudo tar -xvzf /tmp/splunkforwarder-8.0.5-a1a6394cc5ae-Linux-x86_64.tgz -C /opt/splunkforwarder/splunkforwarder-8.0.5

/opt/splunkforwarder/bin/splunk start --accept-license --answer-yes --no-prompt
/opt/splunkforwarder/bin/splunk enable boot-start --accept-license --answer-yes --no-prompt

tar -xvzf  /tmp/UF-cloud_tesco_config_operations-ssloutputs.tar.gz -C /opt/splunkforwarder/etc/apps

touch /opt/splunkforwarder/etc/system/local/inputs.conf
tee /opt/splunkforwarder/etc/system/local/inputs.conf <<EOT
${inputs_conf_file_content}
EOT

touch /opt/splunkforwarder/etc/system/local/fields.conf
tee /opt/splunkforwarder/etc/system/local/fields.conf <<EOT
[env]
INDEXED = true
[application]
INDEXED = true
EOT

/opt/splunkforwarder/bin/splunk restart --accept-license --answer-yes --no-prompt

### End Splunk installation
