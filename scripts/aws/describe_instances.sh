#!/bin/bash

# Args
#  $1: region
#  $2: id

length = $(aws ec2 describe-instances \
    --filters 'Name=tag:pipelineai,Values=workshop' \
    | jq length .Reservations[0].Instances)


for idx in {0..length}; do
  aws ec2 describe-instances \
    --filters 'Name=tag:pipelineai,Values=workshop' \
#    | jq .Reservations[$idx].Instances[$idx].PublicDnsName
done
