#!/bin/bash

# Args
#  $1: region
#  $2: id


# TODO :  ADD TAGS!!

aws ec2 run-instances \
    --key-name pipelineai-workshop \
    --associate-public-ip-address \
    --count 1 \
    --image-id ami-1420866c \
    --security-group-ids sg-aa37acd6 \
    --instance-type p3.2xlarge \
    --user-data file://user-data.txt \
    --block-device-mappings file://root-volume.json 
#    --tag-specifications ResourceType=instance,Tags=[{Key=pipelineai_key,Value=pipelineai_value}]

# user-data logs are here: /var/log/cloud-init-output.log
