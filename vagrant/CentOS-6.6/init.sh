#!/bin/sh

yum -y install epel-release*
cp -Rpf /etc/yum.repos.d/CentOS-Base.repo{,.default}
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
cp -Rpf /etc/yum.repos.d/epel.repo{,.default}
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
sed -i.bak 's/^enabled=1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf
#yum clean all && yum makecache 
#yum -y update kernel* bash openssl*
yum -y update bash openssl*
yum -y install expect ifstat iftop ncdu nethogs iotop glances bash-completion

cat >> /etc/profile <<\EOF
################# DEFINE FUNCTION HERE #############
function na
{
       # netstat -nat | awk '{print $6}' | sort | uniq -c | sort -rn
        ss -na | grep -v "State" | awk '{++state[$1]} END {for ( key in state ) print key, state[key]}'
}
nl () { ss -lnp | tr -s ' ' '\t'; }
nr () { netstat -nr; }
nu () { netstat -lnpu; }
nt () { netstat -lnpt; }
vm () { vmstat -S M 1; }
ff(){ find . -iname "*$1*"; }
fd(){ find . -type d -iname "*$1*"; }
nohist(){ export HISTFILE=/dev/null; }
sus(){ sort | uniq -c | sort -nr "$@"; }
psg(){ ps aux | grep -E "[${1:0:1}]${1:1}|^USER"; }
datediff() {
     d1=$(date -d "$1" +%s)
     d2=$(date -d "$2" +%s)
     echo $(( (d1 - d2) / 86400 )) days
}
genpasswd() {
    local l=$1
     [ "$l" == "" ] && l=16
     tr -dc 'a-zA-Z0-9~!@#$%^&*-_' < /dev/urandom | head -c ${l} | xargs
}
viewconfig() {
     local f="$1"
     [ -f "$1" ] && command egrep -v "^#|^$" "$f" || echo "Error $1 file not found."
}
scan() {
     local network="$1"
     if [ $# == "0" ];then
          echo "USAGE: ./scan ipaddr/mask"
     else
          nmap -sP $network | grep -v "Host" | tail -n +3 | tr '\n' ' ' | sed 's|Nmap|\nNmap|g' | grep "MAC Address" | cut -d " " -f5,8-15
     fi
}
ckp() {
     local ip="$1"
     local ports="$2"
     if [ ! $# == "2" ];then
          echo "USAGE: ./ckp [IP|DOMAIN] PORTS"
     else
        nc -zvw5 $ip $ports
     fi
}

################ END OF FUNCTION DEFINE ############
################# DEFINE ALIAS HERE #############
HISTTIMEFORMAT="%F %T "
#Public
alias rz='rz -be'
alias ll="ls -lth"
alias lh="ls -lth | head"
alias tl="tail -f /var/log/messages"
alias mtr='mtr -nrc 10'
alias less='less -F'
alias nmaping='nmap -v -n -sP'
alias mynmap='nmap -v -n -sP'
alias omnitty='omnitty -W 15 -T 110'
alias nocomment="grep -v '^$\|^\s*\#'"
alias hg='history | grep'
alias mynetcon='lsof -n -P -i +c 15'
#Private
################ END OF ALIAS DEFINE ############
EOF

