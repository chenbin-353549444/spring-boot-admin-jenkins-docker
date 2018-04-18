#!/bin/bash

# 停止admin容器
docker stop admin

# 删除damin容器
docker rm admin

# 删除原来镜像
docker rmi hongfund/admin

# 生成新的镜像
./mvnw install dockerfile:build

# 运行admin容器
docker run --name admin -p 8899:8899 -d hongfund/admin