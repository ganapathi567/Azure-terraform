### Start mount data disk

sudo fdisk /dev/sdc <<EOF
p
w
EOF

sudo mkfs -t ext4 /dev/sdc <<EOF
yes
EOF

sudo mkdir /data
sudo mount /dev/sdc /data

sudo su -c "echo 'UUID=$(sudo blkid /dev/sdc -o value -s UUID) /data ext4 defaults,nofail 1 2'  >> /etc/fstab"

### End mount data disk
