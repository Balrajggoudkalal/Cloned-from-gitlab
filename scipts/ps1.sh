#!/bin/bash

AWS_HOSTNAME=$(aws ec2 describe-instances --region us-east-2 --instance-ids $(curl -s http://169.254.169.254/latest/meta-data/instance-id) --query   "Reservations[*].Instances[*].[Tags[*]]" | grep Name -B1  | head -1 | grep Value  |xargs | awk -F : '{print $2}' | sed -e 's/,//g' -e 's/ //g')

if [ -z "$AWS_HOSTNAME" ]; then 
    if [ `id -u` = 0 ]; then 
      export PS1='\[\e[1;31m\][\u@\h \W]# \[\e[0m\]'
    else
      export PS1='\[\e[1;31m\][\u@\h \W]$ \[\e[0m\]'
    fi

else 
    if [ `id -u` = 0 ]; then 
      export PS1='\[\e[1;31m\][\u@$AWS_HOSTNAME \W]# \[\e[0m\]'
    else
      export PS1='\[\e[1;31m\][\u@$AWS_HOSTNAME \W]$ \[\e[0m\]'
    fi
fi