#!/bin/bash

echo ">>>>>>>>>>>>6.修改内核参数<<<<<<<<<<<<<"
#设置内核参数
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
vm.swappiness = 0
EOF

#网桥设置
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

#加载br_netfilter模块
modprobe br_netfilter
modprobe overlay

#检查是否加载
lsmod | grep br_netfilter

echo ">>>>>>>>>>>>7.安装ipset ipvsadm<<<<<<<<<<<<<"
yum -y install ipset ipvsadm

cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/bash
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack
EOF

#授权、运行、检查是否加载
chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep -e ip_vs -e nf_conntrack


echo ">>>>>>>>>>>>8.安装docker<<<<<<<<<<<<<"
#安装wget
yum install wget -y

#docker yum源 使用阿里镜像源
wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo

#docker安装启动
yum -y install docker-ce
systemctl start docker

#修改cgroup方式(需要和kubelet方式一致)
cat > /etc/docker/daemon.json <<EOF
{
        "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

#重启docker
systemctl restart docker


#添加k8s yum源
echo ">>>>>>>>>>>>9.添加kubelet/kubeadm/kubectl<<<<<<<<<<<<<"
cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
   http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

#安装启动：
yum install -y --setopt=obsoletes=0 kubelet-1.23.6 kubeadm-1.23.6 kubectl-1.23.6

#修改分组驱动（需要和/etc/docker/daemon.json中配置一致）
cat > /etc/sysconfig/kubelet <<EOF
KUBELET_EXTRA_ARGS="--cgroup-driver=systemd"
EOF

#允许启动kubelet
systemctl enable kubelet --now 

