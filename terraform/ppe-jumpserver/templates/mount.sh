### Start mount data disk

disk=$(lsblk | grep -i 100G | cut -d ' '  -f 1)
echo $disk
sudo fdisk /dev/$(lsblk | grep -i 100G | cut -d ' '  -f 1) <<EOF
p
w
EOF

sudo mkfs -t ext4 /dev/$(lsblk | grep -i 100G | cut -d ' '  -f 1) <<EOF
yes
EOF

sudo mkdir /jumpbox
sudo mount /dev/$(lsblk | grep -i 100G | cut -d ' '  -f 1) /jumpbox

sudo su -c "echo 'UUID=$(sudo blkid /dev/$disk -o value -s UUID) /mongodb ext4 defaults,nofail 1 2'  >> /etc/fstab"

### End mount data disk
