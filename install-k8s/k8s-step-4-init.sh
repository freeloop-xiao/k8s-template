#!/bin/bash

kubeadm init \
--apiserver-advertise-address=10.1.1.254 \
--control-plane-endpoint=k8s-1 \
--image-repository registry.cn-hangzhou.aliyuncs.com/google_containers \
--kubernetes-version v1.23.6 \
--service-cidr=10.96.0.0/16 \
--pod-network-cidr=10.97.0.0/16
