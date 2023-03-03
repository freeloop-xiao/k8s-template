#!/bin/bash

#设置主机名称
echo ">>>>>>>>>1.设置主机<<<<<<<<<<<"
hostnamectl set-hostname $1

echo "10.1.1.254 k8s-1" >> /etc/hosts
echo "10.1.0.204 k8s-2" >> /etc/hosts
echo "10.1.1.213 k8s-3" >> /etc/hosts

hostname

#关闭防火墙
echo ">>>>>>>>>2.关闭防火墙<<<<<<<<<<<"
sed -ri 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
systemctl disable firewalld
systemctl stop firewalld
firewall-cmd --state

#同步时间
echo ">>>>>>>>>3.同步时间<<<<<<<<<<<"
yum install nptdate -y
ntpdate ntp1.aliyun.com

#临时关闭swap
echo ">>>>>>>>>4.关闭swap<<<<<<<<<<<"
swapoff -a
sed -ri 's/.*swap.*/#&/' /etc/fstab


#查看内核版本
echo ">>>>>>>>>5.更新内核版本<<<<<<<<<<<"
uname -r

#导入elrepo gpg key
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

#安装elrepo YUM源仓库
yum -y install https://www.elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm

#安装kernel-ml版本，ml为长期稳定版本，lt为长期维护版本
yum --enablerepo="elrepo-kernel" -y install kernel-ml.x86_64

#设置grub2默认引导为0
grub2-set-default 0

#重新生成grub2引导文件
grub2-mkconfig -o /boot/grub2/grub.cfg

#更新后，需要重启，使用升级的内核生效。
reboot

