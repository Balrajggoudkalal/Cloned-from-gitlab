#!/bin/bash

## Following code can help in setting up AMI in AWS for practice of DevOps Tools 

## Checking Internet 
ping -c 2 google.com &>/dev/null 
if [ $? -ne 0 ]; then 
    echo "Internet connection is now working.. Check it .. !!"
    exit 1
fi
## Common Functions 
curl -s https://raw.githubusercontent.com/linuxautomations/scripts/master/common-functions.sh -o /tmp/common.sh &>/dev/null 
source /tmp/common.sh
EPEL=https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm


## Check ROOT USER 
if [ $(id -u) -ne 0 ]; then 
    error "You should be a root/sudo user to perform this script"
    exit 1
fi

## Disabling SELINUX
sed -i -e '/^SELINUX/ c SELINUX=disabled' /etc/selinux/config
Stat $? "Disabling SELINUX"


## Disable firewall 
systemctl disable firewalld &>/dev/nulll 
Stat 0 "Disabling Firewall"

## Updating System Updates
info "Updating System Updates"
yum update -y &>/dev/null 
Stat $? "Updating System Updates"

## Install Base Packages
PACK_LIST="wget zip unzip gzip vim net-tools $EPEL bind-utils"
info "Installing Base Packages"
for package in $PACK_LIST ; do 
    [ "$package" = "$EPEL" ] && rpm -qa | grep epel &>/dev/null && Statt 0 "Installed EPEL" && continue
    yum install $package -y &>/dev/null  
    Statt $? "Installed $package"
done
yum clean all &>/dev/null 

## Fixing SSH timeouts
sed -i -e '/TCPKeepAlive/ c TCPKeepAlive yes' -e '/ClientAliveInterval/ c ClientAliveInterval 10' /etc/ssh/sshd_config
Stat $? "Fixing SSH timeouts"

## Enable color prompt
curl -s https://gitlab.com/cit-devops/intros/raw/master/scipts/ps1.sh -o /etc/profile.d/ps1.sh
chmod +x /etc/profile.d/ps1.sh
Stat $? "Enable Color Prompt"

## Enable idle shutdown
curl -s https://gitlab.com/cit-devops/intros/raw/master/scipts/idle.sh -o /boot/idle.sh 
chmod +x /boot/idle.sh
STAT1=$?

sed -i -e '/idle/ d' /var/spool/cron/root &>/dev/null
echo "*/10 * * * * sh -x /boot/idle.sh &>/tmp/idle.out" >/var/spool/cron/root
chmod 600 /var/spool/cron/root
STAT2=$?
if [ $STAT1 -eq 0 -a $STAT2 -eq 0 ]; then 
    STAT=0
else
    STAT=1
fi 
Stat $? "Enable idle shutdown"

## MISC
echo -e "LANG=en_US.utf-8\nLC_ALL=en_US.utf-8" >/etc/environment

## Enable Password Logins
sed -i -e '/^PasswordAuthentication/ c PasswordAuthentication yes' /etc/ssh/sshd_config
Stat $? "Enable Password Login"

## Setup user passwords
ROOT_PASS=$(head /dev/urandom | tr -dc A-Za-z | head -c 8 ; echo '')
CENTOS_PASS=$(head /dev/urandom | tr -dc A-Za-z | head -c 8 ; echo '')
echo $ROOT_PASS | passwd --stdin &>/dev/null 
echo $CENTOS_PASS | passwd --stdin centos &>/dev/null 
Stat $? "Setup Password for Users"
info "   Following are the Usernames and Passwords"
Infot " centos / $CENTOS_PASS"
Infot "   root   / $ROOT_PASS"
