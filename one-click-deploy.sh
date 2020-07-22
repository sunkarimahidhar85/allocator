#!/bin/bash -e 

./build.sh 
./push.sh

# Auth
kubectl delete -f allocator-rc.yaml
kubectl create -f allocator-rc.yaml

kubectl delete -f allocator-svc.yaml
kubectl create -f allocator-svc.yaml

