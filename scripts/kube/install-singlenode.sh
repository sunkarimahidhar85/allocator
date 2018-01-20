#/bin/bash

# Derived from https://gist.github.com/ericstoekl/1d4372e9398d9cec7ec028629b2c36e2
#          and https://medium.com/@ericstoekl/deploying-openfaas-on-kubernetes-aws-259ec9515e3c

apt-get update
apt-get install -qy docker.io

apt-get update
apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
  
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
  
apt-get update
apt-get install -y kubelet kubeadm kubernetes-cni

kubeadm init --kubernetes-version stable-1.8

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl get all -n kube-system

# TODO:  Pin this clone!!
#git clone https://github.com/openfaas/faas-netes

#cd faas-netes
#kubectl apply -f namespaces.yml
#kubectl apply -f yaml/

#kubectl get pod --namespace=openfaas
#kubectl get pod --namespace=openfaas-fn
