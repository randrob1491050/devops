#!/bin/sh
#Author: Tonny@51.com
#Date: 2008.06.16
#PurePose: daily backup for nagios

archive_dir="/data/backup/nagios_archive"
date=`date +%Y%m%d`

echo $date >> $archive_dir/daily_nagios_backup.log
cd /data/nagios
tar cf - . | gzip -qc > $archive_dir/nagios_archive_0.tar.gz
if [ $? -eq 0 ];then 
        echo "backup done successful!" >> $archive_dir/daily_nagios_backup.log
                else
        echo "backup done fail!" >> $archive_dir/daily_bagios_backup.log
fi 

cd $archive_dir
rm -f nagios_archive_7.tar.gz
for i in 7 6 5 4 3 2 1
do
j=`expr $i - 1`
mv -f nagios_archive_$j.tar.gz nagios_archive_$i.tar.gz
done

/usr/local/bin/rsync -avz nagios_archive_*.tar.gz 192.168.5.251::nagios_backup