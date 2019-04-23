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
    yum install $package -y &>/dev/null  
    [ "$package" = "$EPEL" ] && rpm -qa | grep epel &>/dev/null
    [ $? -eq 0 ] && Statt 0 "Installed EPEL" && continue
    Statt $? "Installed $package"
done