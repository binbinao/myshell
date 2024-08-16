#!/bin/bash

# 定义腾讯云的镜像加速站点
MIRROR_URL="https://mirror.ccs.tencentyun.com"

# 检查Docker是否正在运行
if ! systemctl is-active docker &> /dev/null
then
    echo "Docker服务未运行，正在启动Docker服务..."
    sudo systemctl start docker
fi

# 检查Docker配置文件是否存在，如果不存在则创建
if [ ! -f "/etc/docker/daemon.json" ]; then
    echo "创建Docker配置文件..."
    touch /etc/docker/daemon.json
fi

# 编辑Docker配置文件，添加镜像加速配置
echo "{
    \"registry-mirrors\": [\"$MIRROR_URL\"]
}" | sudo tee /etc/docker/daemon.json > /dev/null

# 重启Docker服务使配置生效
echo "重启Docker服务以应用镜像加速配置..."
sudo systemctl restart docker

echo "Docker镜像加速配置完成。"