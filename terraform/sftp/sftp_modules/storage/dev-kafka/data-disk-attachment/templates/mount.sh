### Start mount data disk

sudo fdisk /dev/sdc <<EOF
p
w
EOF

sudo mkfs -t ext4 /dev/sdc <<EOF
yes
EOF

sudo mkdir /zookeeper_kafka
sudo mount /dev/sdc /zookeeper_kafka

sudo su -c "echo 'UUID=$(sudo blkid /dev/sdc -o value -s UUID) /zookeeper_kafka ext4 defaults,nofail 1 2'  >> /etc/fstab"

### End mount data disk
