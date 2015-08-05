#!/bin/sh

###########################################################
# Desc:  Daily Database Backup For Slave                  #
# Type:  Myisam                                           #
# Backup files will be saved for 7 days                   #
# Author:  Tonnyom Wang                                   #
# Version: 1.1  2013-10-28                                #
###########################################################

mysql_password='xxxxxxxxxxxx'
mysql_sock='/tmp/mysql.sock'
mysql_string="/usr/local/mysql/bin/mysql -uroot -p${mysql_password} -S ${mysql_sock}"
mysqldump_string="/usr/local/mysql/bin/mysqldump -uroot -p${mysql_password} -S ${mysql_sock}"
data_dir=`$mysql_string -s -e "SHOW VARIABLES like 'datadir'"|awk '{print $2}'`
bak_rdir=/app/dbbackup
bak_filename=db_`date '+%Y%m%d%H%M'`
expdt=`date -d "7 day ago " +%Y%m%d`
tmp_file="/tmp/backup_info.tmp"

echo "backup start time:`date`"

   if [ `$mysql_string -e "SHOW status"|grep -w Slave_running|awk '{print $2}'` = "OFF" ]
      then
          echo "It's not slave or slave status not running"

      else
          cd $data_dir;
          need_bak_file="`cd $data_dir;find . -type d -maxdepth 1 -mindepth 1|xargs` slave.info"

          $mysql_string -e "
          flush TABLES WITH READ LOCK;
          show slave status \G
          \! cp relay-log.info slave.info;
          \! tar -zcvf $bak_rdir/"$bak_filename".tgz $need_bak_file;
          unlock tables;
          ">$tmp_file

          if [ $? = 0 ]
          then
                cd $bak_rdir
                Master_Ip=`grep -w Master_Host $tmp_file|awk '{print $2}'`
		            mv  "$bak_filename".tgz "$bak_filename"_"$Master_Ip".tgz
		            rm -f $tmp_file  $data_dir/slave.info
          else
                 echo    "Package backup files has failed"
		 rm -f $bak_rdir/"$bak_filename".tgz
		 rm -f $tmp_file

          fi
   fi

echo "backup stop time:`date`"

######Clear expired backup files,just keep only 7 days######

for file in `ls  $bak_dir |egrep 'tgz'`

   do
     seq=${file:3:8}
     if [ $seq -le $expdt ]

       then

      rm -f $bak_dir/$file


     fi
done
