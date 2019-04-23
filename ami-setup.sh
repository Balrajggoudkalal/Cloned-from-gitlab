#!/bin/bash

## Following code can help in setting up AMI in AWS for practice of DevOps Tools 

## Check ROOT USER 
if [ $(id -u) -ne 0 ]; then 
    Error "You should be a root/sudo user to perform this script"
fi


## Disabling SELINUX