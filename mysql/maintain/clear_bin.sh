#!/bin/sh

###########################################################
# Desc:  Clear Mysql Bin Logs For Hours Interval          #
# Author:  Tonnyom Wang                                   #
# Version: 0.3  2014-07-12                                #
###########################################################

indexFile=xxx_binlog.index
binLogDir=/data/mysql/mysql.bin
slaveIP="x.x.x.x"
purgeFile=""
masterPass="xxxxxxxxxxx"

relayFile=`mysql -urepl -preplication -h$slaveIP -e"show slave status \G;" | grep Relay_Master_Log_File | awk -F: '{print $2}' | sed 's/^[ \t]*//g'`

while read itemFile;do
  if [ "$itemFile" != "$binLogDir/$relayFile" ];then
    purgeFile=$itemFile
    #echo $purgeFile
  else
    break
  fi
done < $binLogDir/$indexFile

purgeFile=`echo $purgeFile | awk -F/ '{print $NF}'`

mysql -uroot -p$masterPass -e"purge master logs to '$purgeFile'"
