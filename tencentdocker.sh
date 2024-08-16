#!/bin/bash

# 检查Docker是否正在运行
if ! systemctl is-active docker &> /dev/null
then
    echo "Docker服务未运行，请先启动Docker服务。"
    exit 1
fi

# 配置腾讯云Docker镜像加速器
DOCKER_CONFIG="/etc/docker/daemon.json"

# 检查配置文件是否存在，如果不存在则创建
if [ ! -f "$DOCKER_CONFIG" ]; then
    echo "创建Docker配置文件..."
    touch $DOCKER_CONFIG
fi

# 添加或更新镜像加速器配置
echo "配置腾讯云Docker镜像加速器..."
cat > $DOCKER_CONFIG <<EOF
{
    "registry-mirrors": ["https://mirror.ccs.tencentyun.com"]
}
EOF

# 重新加载Docker守护进程配置
echo "重新加载Docker守护进程配置..."
systemctl daemon-reload
systemctl restart docker

echo "Docker镜像加速器配置完成。"