#!/bin/bash
# 停止admin容器
(docker stop admin && echo "stop success") || echo "stop error";

# 删除damin容器
(docker rm admin && echo "rm success") || echo "rm error";

# 删除原来镜像
(docker rmi admin && echo "rmi success") || echo "rmi error";

# 生成新的镜像
docker build -t admin .;

# 运行admin容器
docker run --name admin \
    -p 8899:8899 \
    -d \
    -e TZ=Asia/Shanghai \
    admin