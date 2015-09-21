#!/bin/sh
FSTYPE=ntfs
DEVICE=`blkid | grep $FSTYPE | cut -d' ' -f1 | cut -d: -f1`
LABEL=`blkid -s LABEL -o value $DEVICE`
USER="username"
PASS="password"
mkdir -p /mnt/$LABEL/downloads/_torrents/
mkdir -p /mnt/$LABEL/downloads/_torrents/_complete
mkdir -p /mnt/$LABEL/downloads/_torrents/_incomplete
mkdir -p /mnt/$LABEL/downloads/_torrents/_watch
sed -i 's#"download-dir": "/var/lib/transmission-daemon/downloads",#"download-dir": "/mnt/'$LABEL'/downloads/_torrents/_complete",#g' /etc/transmission-daemon/settings.json
sed -i 's#"download-dir": "/home/debian-transmission/Downloads",#"download-dir": "/mnt/'$LABEL'/downloads/_torrents/_complete",#g' /etc/transmission-daemon/settings.json
sed -i 's#"incomplete-dir": "/var/lib/transmission-daemon/Downloads",#"incomplete-dir": "/mnt/'$LABEL'/downloads/_torrents/_incomplete",#g' /etc/transmission-daemon/settings.json
sed -i 's#"incomplete-dir": "/home/debian-transmission/Downloads",#"incomplete-dir": "/mnt/'$LABEL'/downloads/_torrents/_incomplete",#g' /etc/transmission-daemon/settings.json
sed -i 's#"incomplete-dir-enabled": false,#"incomplete-dir-enabled": true,#g' /etc/transmission-daemon/settings.json
sed -i 's#"rpc-password".*#"rpc-password": "'$PASS'",#g' /etc/transmission-daemon/settings.json
sed -i 's#"rpc-url": "/transmission/",#"rpc-url": "/trans/",#g' /etc/transmission-daemon/settings.json
sed -i 's#"rpc-username": "transmission",#"rpc-username": "'$USER'",#g' /etc/transmission-daemon/settings.json
sed -i 's#"rpc-whitelist": "127.0.0.1",#"rpc-whitelist": "127.0.0.1,192.168.*",#g' /etc/transmission-daemon/settings.json
sed -i 's#"utp-enabled": true#"utp-enabled": true,#g' /etc/transmission-daemon/settings.json
sed -i 's#}##g' /etc/transmission-daemon/settings.json
echo '    "watch-dir": "/mnt/'$LABEL'/downloads/_torrents/_watch",' |   tee -a /etc/transmission-daemon/settings.json
echo '    "watch-dir-enabled": true' |   tee -a /etc/transmission-daemon/settings.json
echo "}" |   tee -a /etc/transmission-daemon/settings.json
