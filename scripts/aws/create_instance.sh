#!/bin/bash

# Args
#  $1: region
#  $2: id

aws ec2 run-instances \
    --key-name pipelineai-workshop \
    --count 1 \
    --image-id ami-1420866c \
    --instance-type p3.2xlarge \
    --associate-public-ip-address \
    --security-group-ids sg-aa37acd6 \
    --user-data file://user-data.txt \
    --block-device-mappings file://root-volume.json \
    --iam-instance-profile 'Arn=arn:aws:iam::954636985443:instance-profile/pipelineai-workshop' \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=pipelineai,Value=workshop}]' 

# user-data logs are here: /var/log/cloud-init-output.log
