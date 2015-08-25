#!/bin/sh

###########################################################
# Desc:  Centos System init Scripts On Vagrant            #
# Author:  Tonnyom Wang                                   #
# Version: 1.2  2015-08-03                                #
###########################################################

os_version=`cat /etc/issue | grep release | awk -F" " '{print $3}' | cut -b1`

debug_info () {
    echo ${os_version}
}

base_setup () {
    yum -y install epel-release*
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-${os_version}.repo
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-${os_version}.repo
    sed -i.bak 's/^enabled=1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf
    sed -i.bak 's/^SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config
    yum clean all && yum makecache
    yum -y groupinstall "Development Tools"
    yum -y install kernel-devel-`uname -r` kernel-headers-`uname -r`
    yum -y install ncurses-devel bzip2 gcc make expect ifstat iftop ncdu nethogs iotop glances bash-completion
    #yum -y update kernel* bash openssl*
}


if [[ ${os_version} == 5 ]]; then
    #debug_info
    base_setup
elif [[ ${os_version} == 6 ]]; then
    #debug_info
    base_setup
else
    export os_version="7"
    #debug_info
    base_setup
fi
