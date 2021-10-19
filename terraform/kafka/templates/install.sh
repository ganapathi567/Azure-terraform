#!/bin/bash

sudo mv /etc/security/limits.conf /etc/security/limits.conf-old
sudo touch /etc/security/limits.conf
sudo tee /etc/security/limits.conf <<EOT
${ulimit_content}
EOT

sudo touch /home/${admin_username}/mount.sh
sudo tee /home/${admin_username}/mount.sh <<EOT
${data_disk_mount_script_content}
EOT
sudo sh /home/${admin_username}/mount.sh

${appdynamics_installation_file_content}

sudo su
#sudo yum update -y
sudo yum -y install java-1.8.0-openjdk wget

sudo touch /etc/profile.d/java-setup.sh
tee /etc/profile.d/java-setup.sh <<EOT
${java_setup_content}
EOT

source /etc/profile.d/java-setup.sh

adduser --shell /bin/bash --no-create-home kafka
adduser --shell /bin/bash --no-create-home zk

mkdir -p /zookeeper_kafka/zk_data
#chown zk:zk /zookeeper_kafka/zk_data
mkdir -p /zookeeper_kafka/zk_logs
#chown zk:zk /zookeeper_kafka/zk_logs
mkdir -p /zookeeper_kafka/kafka_logs

touch /zookeeper_kafka/zk_data/myid
tee /zookeeper_kafka/zk_data/myid <<EOT
${id}
EOT
#chown -h zk:zk /zookeeper_kafka/zk_data/myid

cd /zookeeper_kafka
#wget -nc https://www-us.apache.org/dist/zookeeper/zookeeper-3.6.1/apache-zookeeper-3.6.1-bin.tar.gz
sudo wget -nc https://archive.apache.org/dist/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz 
sudo tar -xvf zookeeper-3.4.10.tar.gz
mv zookeeper-3.4.10/conf/zoo.cfg zookeeper-3.4.10/conf/zoo.cfg-old
touch zookeeper-3.4.10/conf/zoo.cfg
tee zookeeper-3.4.10/conf/zoo.cfg <<EOT
${config_file_content}
EOT

touch zookeeper-3.4.10/conf/zookeeper_jaas.conf
tee zookeeper-3.4.10/conf/zookeeper_jaas.conf <<EOT
${zookeeper_jaas_content}
EOT

touch zookeeper-3.4.10/conf/java.env
tee zookeeper-3.4.10/conf/java.env <<EOT
${java_env_content}
EOT

touch /etc/systemd/system/zookeeper.service
tee /etc/systemd/system/zookeeper.service <<EOT
${service_file_content_zk}
EOT

#mkdir -p /zookeeper_kafka/log/kafka
#chown kafka:kafka /zookeeper_kafka/log/kafka

cd /zookeeper_kafka
sudo wget -nc https://archive.apache.org/dist/kafka/2.3.0/kafka_2.12-2.3.0.tgz 
sudo tar -xvf kafka_2.12-2.3.0.tgz
#chown kafka:kafka -R kafka_2.12-2.3.0
#chown -h kafka:kafka kafka_2.12-2.3.0
mv kafka_2.12-2.3.0/config/server.properties kafka_2.12-2.3.0/config/server.properties-old
touch kafka_2.12-2.3.0/config/server.properties
tee kafka_2.12-2.3.0/config/server.properties <<EOT
${properties_file_content}
EOT
#chown -h kafka:kafka kafka_2.12-2.3.0/config/server.properties

sudo touch kafka_2.12-2.3.0/config/kafka_server_jaas.conf
tee kafka_2.12-2.3.0/config/kafka_server_jaas.conf <<EOT
${jaas_file_content}
EOT
#chown -h kafka:kafka kafka_2.12-2.3.0/config/kafka_server_jaas.conf

sudo touch kafka_2.12-2.3.0/config/kafka_opts
tee kafka_2.12-2.3.0/config/kafka_opts <<EOT
${kafka_opts_content}
EOT
#chown -h kafka:kafka kafka_2.12-2.3.0/config/kafka_opts

touch /etc/systemd/system/kafka.service
tee /etc/systemd/system/kafka.service <<EOT
${service_file_content}
EOT

sleep ${sleep}

sudo yum install firewalld -y
systemctl status firewalld
systemctl restart firewalld
systemctl enable firewalld

firewall-cmd --zone=public --add-port=2181/tcp --permanent
firewall-cmd --zone=public --add-port=2800/tcp --permanent
firewall-cmd --zone=public --add-port=3800/tcp --permanent
firewall-cmd --reload

cd /zookeeper_kafka/zookeeper-3.4.10/bin
export SERVER_JVMFLAGS="-Djava.security.auth.login.config=/zookeeper_kafka/zookeeper-3.4.10/conf/zookeeper_jaas.conf"
./zkServer.sh start-foreground ../conf/zoo.cfg & <<EOT
EOT

#systemctl daemon-reload
#systemctl restart zookeeper

firewall-cmd --zone=public --add-port=9092/tcp --permanent
firewall-cmd --zone=public --add-port=9093/tcp --permanent
firewall-cmd --reload

cd /zookeeper_kafka/kafka_2.12-2.3.0/bin/
export KAFKA_OPTS="-Djava.security.auth.login.config=/zookeeper_kafka/kafka_2.12-2.3.0/config/kafka_server_jaas.conf"
./kafka-server-start.sh -daemon ../config/server.properties

#systemctl daemon-reload
#systemctl restart kafka
