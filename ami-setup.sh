#!/bin/bash

## Following code can help in setting up AMI in AWS for practice of DevOps Tools 

## Check ROOT USER 
if [ $(id -u) -ne 0 ]; then 
    Error "You should be a root user to perform this script"


## Disabling SELINUX