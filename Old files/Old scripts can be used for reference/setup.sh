#!/bin/bash

#print pi ip-address
hostname -I

sudo apt-get update
sudo apt=get upgrade -y
sudo apt-get install net-tools
#sudo apt-get install ntfs-3g -y
#sudo apt-get install exfat-fuse exfat-utils
sudo apt-get install samba samba-common-bin -y
mkdir /home/pi/shared

sudo cat << EOT >> /etc/samba/smb.conf
[Zandbak-Share]
path = /home/pi/shared
writeable=Yes
create mask=0777
directory mask=0777
public=no
EOT

sudo smbpasswd -a pi # password: Welkom01!
sudo systemctl restart smbd

0946-141D
8914-141A

1000
1000

echo "UUID=0946-141D /home/pi/shared/usb1 auto defaults,auto,users,rw,nofail,noatime 0 0"
echo "UUID=8914-141A /home/pi/shared/usb2 auto defaults,auto,users,rw,nofail,noatime 0 0"