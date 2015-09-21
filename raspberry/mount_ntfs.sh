#!/bin/sh
FSTYPE=ntfs
DEVICE=`blkid | grep $FSTYPE | cut -d' ' -f1 | cut -d: -f1`
LABEL=`blkid -s LABEL -o value $DEVICE`
UUID=`blkid -s UUID -o value $DEVICE`
echo $DEVICE $LABEL $UUID
mkdir /mnt/$LABEL
chown -R osmc:osmc /mnt/$LABEL
cp /etc/fstab /etc/fstab.bak
echo "$DEVICE /mnt/$LABEL $FSTYPE uid=osmc,gid=osmc 0 0" | tee -a /etc/fstab
#echo "$DEVICE /mnt/$LABEL $FSTYPE uid=osmc,gid=osmc 0 0"
cp /boot/cmdline.txt /boot/cmdline.txt.bak
echo "$(cat /boot/cmdline.txt) rootdelay=5" | tee /boot/cmdline.txt
mount -a
