### Start mount data disk

disk=$(lsblk | grep -i 250G | cut -d ' '  -f 1)
echo $disk
sudo fdisk /dev/$(lsblk | grep -i 250G | cut -d ' '  -f 1) <<EOF
p
w
EOF

sudo mkfs -t ext4 /dev/$(lsblk | grep -i 250G | cut -d ' '  -f 1) <<EOF
yes
EOF

sudo mkdir /zookeeper_kafka
sudo mount /dev/$(lsblk | grep -i 250G | cut -d ' '  -f 1) /zookeeper_kafka

sudo su -c "echo 'UUID=$(sudo blkid /dev/sdc -o value -s UUID) /zookeeper_kafka ext4 defaults,nofail 1 2'  >> /etc/fstab"

### End mount data disk
