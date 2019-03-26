#!/bin/sh
# 安装 docker并启动Yearning

#----------------- 安装 docker-compose --------------------
pip_args="-i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com"
# 如果没有pip命令，先安装
if ! $(command -v pip > /dev/null); then
	yum -y install epel-release
	yum -y install python-pip
fi

pip install --upgrade pip $pip_args

if ! $(command -v docker-compose > /dev/null); then
    pip install docker-compose $pip_args
fi

pip install --upgrade docker-compose $pip_args

#----------------- 安装 Docker --------------------
if command -v docker > /dev/null; then
    echo "  [Error]: docker already install.
  [Note]: Maybe you want command \"docker-compose up -d\" to install Yearning！"
    exit
fi
# 设置Docker数据文件
mkdir /data/docker_file
ln -s /data/docker_file /var/lib/docker
# 安装依赖
yum install -y yum-utils device-mapper-persistent-data lvm2
# 设置Docker的yum源
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
# 安装最新稳定版
yum install docker-ce -y
# 加入开机启动、启动
systemctl start docker && systemctl enable docker
# 验证Docker安装
docker version
