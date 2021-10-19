### Start mount data disk

sudo fdisk /dev/sdc <<EOF
p
w
EOF

sudo mkfs -t ext4 /dev/sdc <<EOF
yes
EOF

#add group
sudo groupadd sftpuser

#add user
sudo useradd frs

#add 'frs'user to group 'sftpuser'
sudo usermod -aG sftpuser frs

sudo mkdir /sftp
sudo mount /dev/sdc /sftp

sudo su -c "echo 'UUID=$(sudo blkid /dev/sdc -o value -s UUID) /sftp ext4 defaults,nofail 1 2'  >> /etc/fstab"

sudo chown -R root:sftpuser /sftp
cd /sftp
sudo mkdir shared
sudo mkdir store-finalization user
sudo mkdir bank-statement user
sudo chmod -R 755 /sftp

### End mount data disk

