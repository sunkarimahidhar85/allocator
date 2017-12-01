#!/bin/bash

# Args:
#   $1:  zone: (us-west1-b (230), us-east1-d (150), europe-west1-b (200), asia-east1-a (64))
#   $2:  index

gcloud beta compute instances create pipeline-gpu-$1-$2 \
    --machine-type n1-standard-4 \
    --min-cpu-platform "Intel Broadwell" \
    --zone $1 \
    --boot-disk-size=100GB --boot-disk-auto-delete --boot-disk-type=pd-ssd \
    --accelerator type=nvidia-tesla-k80,count=1 \
    --image ubuntu-1604-xenial-v20170307 \
    --image-project ubuntu-os-cloud \
    --maintenance-policy TERMINATE \
    --restart-on-failure \
    --metadata startup-script='#!/bin/bash
    sudo apt-get update
    sudo apt-get install -y wget
    sudo apt-get install -y linux-headers-$(uname -r)
    sudo apt-get install -y gcc
    sudo apt-get install -y make
    sudo apt-get install -y g++
    wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
    sudo dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
    sudo apt-get update
    sudo apt-get install -y cuda
    export PATH=$PATH:/usr/local/cuda/bin
    sudo curl -fsSL https://get.docker.com/ | sh
    sudo curl -fsSL https://get.docker.com/gpg | sudo apt-key add -
    wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker_1.0.1-1_amd64.deb
    sudo dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb
    sudo nvidia-docker run -itd --name=gpu-tensorflow-spark -p 80:80 -p 50070:50070 -p 39000:39000 -p 9000:9000 -p 9001:9001 -p 9002:9002 -p 9003:9003 -p 9004:9004 -p 6006:6006 -p 8754:8754 -p 7077:7077 -p 6066:6066 -p 6060:6060 -p 6061:6061 -p 4040:4040 -p 4041:4041 -p 4042:4042 -p 4043:4043 -p 4044:4044 -p 2222:2222 -p 5050:5050 fluxcapacitor/gpu-tensorflow-spark:master'
