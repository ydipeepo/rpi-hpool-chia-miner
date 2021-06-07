FROM ubuntu:latest

#
# 准备依赖安装包
#

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y wget unzip

#
# 下载矿机程序并放置在指定的目录中
#

RUN mkdir -p hpool-chia-miner && \
	wget -O miner.zip https://github.com/hpool-dev/chia-miner/releases/download/v1.4.0-2/HPool-Miner-chia-v1.4.0-2-arm.zip && \
	unzip miner.zip && \
	mv linux-arm/* /hpool-chia-miner && \
	rm -r /linux-arm/ /miner.zip

#
# 将启动脚本设为入口点
#

WORKDIR /hpool-chia-miner
ADD ./bootstrap.sh /hpool-chia-miner/bootstrap.sh
ENTRYPOINT ["bash", "/hpool-chia-miner/bootstrap.sh"]
