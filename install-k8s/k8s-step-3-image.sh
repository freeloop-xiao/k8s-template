#!/bin/bash
images=(
kube-apiserver:v1.23.6
kube-controller-manager:v1.23.6
kube-scheduler:v1.23.6
kube-proxy:v1.23.6
pause:3.6
etcd:3.5.1-0
coredns:v1.8.6
)
for imageName in ${images[@]} ; do
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
done
