#!/bin/sh

###########################################################
# Desc:  Daily Database Backup For Innodb Master          #
# Type:  Innodb                                           #
# Backup files will be saved for 30 days                  #
# Author:  Tonnyom Wang                                   #
# Version: 0.6  2015-08-02                                #
###########################################################

mysql_password='xxxxxxxxxxxx'
mysqldump_string="/usr/local/mysql/bin/mysqldump -uroot -p${mysql_password}"
bak_filename=`date '+%Y%m%d%H%M'`

bak_local_dir='/dbbackup'
ifconfig_eth1=`ifconfig | grep -w -A 1 eth1 | grep 'inet addr' | head -1 | awk -F: '{print $2}' | awk '{print $1}'`

bak_remote_ip='x.x.x.x'
bak_remote_dir='/dbbackup/'

expdt=`date -d "30 day ago" +%Y%m%d`


echo "Backup Start Time:`date`"

### check and mkdir dak dirs with local
if [ ! -d ${bak_local_dir} ]
then
    mkdir -p ${bak_local_dir};chown -R mysql:mysql ${bak_local_dir}
fi

### mysqldump t.sql and d.sql
$mysqldump_string --master-data --single-transaction -d -A >${bak_local_dir}/t_${bak_filename}.sql &
$mysqldump_string --master-data --single-transaction -t -A >${bak_local_dir}/d_${bak_filename}.sql &

### Package and Sync bak.tgz
if [ $? = 0 ]
then
    cd ${bak_local_dir}
    tar -zcvf db_${bak_filename}_${ifconfig_eth1}.tgz t_${bak_filename}.sql d_${bak_filename}.sql
    scp db_${bak_filename}_${ifconfig_eth1}.tgz root@${bak_remote_ip}:${bak_remote_dir}

    if [ $? = 0 ]
    then
        rm -f t_${bak_filename}.sql d_${bak_filename}.sql
        echo "mysqldump and package backup files has succeed"
    else
        echo "mysqldump and package backup files has failed"
    fi
else
    echo "mysqldump and package backup files has failed"
fi

echo "Backup Stop Time:`date`"

### Clear expired backup files,just keep 30 days
for file in `ls  ${bak_local_dir} |grep db_${bak_filename}_${ifconfig_eth1}.tgz`
do
    seq=${file:3:8}
    if [ $seq -lt $expdt ]
    then
        rm -f ${bak_local_dir}/${file}
    fi
done
