#!/bin/sh

###########################################################
# Desc:  Daily Database Backup For Mutil Slave            #
# Type:  Innodb                                           #
# Backup files will be saved for 7 days                   #
# Author:  Tonnyom Wang                                   #
# Version: 1.1  2013-10-28                                #
###########################################################

for mysql_sock in /tmp/mysql.sock101 /tmp/mysql.sock102
do

mysql_password='xxxxxxxxxxxx'
#mysql_sock='/tmp/mysql.sock'
mysql_string="/usr/local/mysql/bin/mysql -uroot -p${mysql_password} -S ${mysql_sock}"
mysqldump_string="/usr/local/mysql/bin/mysqldump -uroot -p${mysql_password} -S ${mysql_sock}"
data_dir=`$mysql_string -s -e "SHOW VARIABLES like 'datadir'"|awk '{print $2}'`
bak_rdir=/dbbackup
bak_filename=`date '+%Y%m%d%H%M'`
expdt=`date -d "7 day ago " +%Y%m%d`

echo "backup start time:`date`"

   if [ ! -d ${bak_rdir} ]
   then
	mkdir -p ${bak_rdir};chown -R mysql:mysql ${bak_rdir}
   fi

   if [ `$mysql_string -e "SHOW status"|grep -w Slave_running|awk '{print $2}'` = "OFF" ]
      then
          echo "It's not slave or slave status not running"

      else
          $mysql_string -e "stop slave;"
          cd $data_dir;

          logerrname=`grep log-error /etc/my.cnf|awk -F= '{print $2}'`
          if [ "$logerrname" = "" ]
               then
               logerrname=`hostname`
          fi

          rm -f $logerrname.err_bak
          $mysql_string -e "show slave status \G" >$bak_rdir/slave_info
          $mysql_string -e "flush tables;"
          $mysqldump_string --single-transaction -d -A >$bak_rdir/t_$bak_filename.sql &
          $mysqldump_string -f --master-data --single-transaction -t -A >$bak_rdir/d_$bak_filename.sql &
          $mysql_string -e "start slave;"
          rm -f $logerrname.err_bak
          wait

          if [ $? = 0 ]
             then
                 cd $bak_rdir
                 Master_Ip=`grep -w Master_Host slave_info|awk '{print $2}'`
                 tar -zcvf db_"$bak_filename"_"$Master_Ip".tgz t_"$bak_filename".sql d_"$bak_filename".sql slave_info >/dev/null
                 if [ $? = 0 ]
                    then

                        rm -f t_"$bak_filename".sql d_"$bak_filename".sql slave_info

                    else
                        rm -f db_"$bak_filename"_"$Master_Ip".tgz
                        echo "Package backup files has failed"

                 fi
             else
             echo    "mysqldump backup files has failed"


          fi
   fi

done

echo "backup stop time:`date`"

######Clear expired backup files,just keep only 7 days######

for file in `ls  $bak_rdir |egrep '$Master_Ip.tgz'`

   do
     seq=${file:3:8}
     if [ $seq -lt $expdt ]

       then

      rm -f $bak_rdir/$file


     fi
done
