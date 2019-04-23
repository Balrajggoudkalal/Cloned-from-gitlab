#!/bin/bash

## Following code can help in setting up AMI in AWS for practice of DevOps Tools 

## Checking Internet 
ping -c 2 google.com &>/dev/null 
if [ $? -ne 0 ]; then 
    echo "Internet connection is now working.. Check it .. !!"
fi
## Common Functions 


## Check ROOT USER 
if [ $(id -u) -ne 0 ]; then 
    Error "You should be a root/sudo user to perform this script"
fi


## Disabling SELINUX