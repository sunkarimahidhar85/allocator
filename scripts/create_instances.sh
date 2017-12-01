#!/bin/bash

# Args
#   $1:  zone: (us-west1-b (230), us-east1-d (150), europe-west1-b (200), asia-east1-a (64))
#   $2: num_instances

for idx in `seq 1 $2`;
do
  nohup ./create_instance.sh $1 $idx > a-$1-$idx.out &
done
