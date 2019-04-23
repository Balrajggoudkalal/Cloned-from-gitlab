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

## Setting up 