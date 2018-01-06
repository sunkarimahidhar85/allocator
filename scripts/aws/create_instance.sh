#!/bin/bash

# Args
#  $1: region
#  $2: id

# TODO 
aws ec2 run-instances \
    --key-name pipeline-training-aws \
    --associate-public-ip-address \
    --count 1 \
    --image-id ami-1420866c \
    --security-group-ids sg-aa37acd6 \
    --instance-type p3.2xlarge \
    --user-data file://create_instance_user_data.txt \
    --block-device-mappings file://create_instance_root_volume.json 
#    --tag-specifications ResourceType=instance,Tags=[{Key=pipelineai_key,Value=pipelineai_value}]
