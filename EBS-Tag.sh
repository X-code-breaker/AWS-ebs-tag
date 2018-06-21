#!/bin/bash
#!/usr/bin/aws

a=Reservations[].Instances[].[Tags[?Key==\`${1}\`].Value[]]
b=Reservations[].Instances[].[Tags[?Key==\`${2}\`].Value[]]
c=Reservations[].Instances[].[Tags[?Key==\`${3}\`].Value[]]

vol=`ec2-describe-volumes --region us-west-2 | grep VOLUME | awk '{print $2}'`
for i in $vol
  do
   insid=`ec2-describe-volumes --region us-west-2 | grep ${i} | grep ATTACHMENT | awk '{print $3}'`
   if [ -n "$i" ]
   then
     key1=`aws ec2 describe-instances --instance-ids ${insid} --query ${a} --output text`
     key2=`aws ec2 describe-instances --instance-ids ${insid} --query ${b} --output text`
     key3=`aws ec2 describe-instances --instance-ids ${insid} --query ${c} --output text`
     aws ec2 create-tags --region us-west-2 --resources ${i} --tags Key=${1},Value=${key1} Key=${2},Value=\'${key2}\' Key=${3},Value=${key3}
  else
     echo ${i} is free
   fi
 done
