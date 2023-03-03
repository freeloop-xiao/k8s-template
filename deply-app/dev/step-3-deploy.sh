#!/bin/bash
#更新重启的过程中会重新拉取镜像
#docker system prune -af 清理节点为使用的镜像
kubectl rollout restart deployment dev-zh-geo -n dev-zh

