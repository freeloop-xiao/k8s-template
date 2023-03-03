#!/bin/bash
#查看环境变量是否生效
kubectl  exec -it  -n mysql  infra-mysql-656f47c8d5-q6lsx -- env | grep -i mysql

#进入mysql容器中执行命令连接数据库
kubectl exec -it -n mysql  infra-mysql-7b7776d7d6-2kc29 -- bash
