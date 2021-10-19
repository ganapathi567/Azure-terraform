### Start mount data disk

disk=$(lsblk | grep -i 500G | cut -d ' '  -f 1)
echo $disk
sudo fdisk /dev/$(lsblk | grep -i 500G | cut -d ' '  -f 1) <<EOF
p
w
EOF

sudo mkfs -t ext4 /dev/$(lsblk | grep -i 500G | cut -d ' '  -f 1) <<EOF
yes
EOF

sudo mkdir /mongodb
sudo mount /dev/$(lsblk | grep -i 500G | cut -d ' '  -f 1) /mongodb

sudo su -c "echo 'UUID=$(sudo blkid /dev/sdc -o value -s UUID) /mongodb ext4 defaults,nofail 1 2'  >> /etc/fstab"

sudo useradd mongodb
sudo chown -R mongodb:mongodb /mongodb
cd /mongodb
sudo mkdir data
sudo mkdir logs
sudo chmod -R 777 /mongodb

### End mount data disk
