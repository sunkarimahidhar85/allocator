#!/bin/bash

# Args
#  $1: zone (us-east1-c (50))
#  $2: num_instances

for idx in `seq 200 $2`;
do
  nohup ./create_instance_p100.sh $1 $idx > a-$1-$idx.out &
done
