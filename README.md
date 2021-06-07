# 在树莓派 4B 上 HPOOL Chia 挖矿

通过 Docker 或 K8S 运行 HPOOL Chia 挖矿软件。这是非官方的。
虽然省略了前提条件但是使用了 Ubuntu Server 的最新版本。

## 建造 Docker 镜像

下载来并解压缩文件后在树莓派上运行:

```bash
$ sudo docker build . -t rpi-hpool-chia-miner
```

## 在 Docker 上运行时

以以下命令开始:

```bash
$ sudo docker run \
	-e API_KEY=********-****-****-****-************ \
	-e SCAN_INTERVAL=15 \
	-v /mnt/sda1:/plot-0 \
	-v /mnt/sdb1:/plot-1 \
	-it rpi-hpool-chia-miner
```

* `API_KEY`: 这里记载了 HPOOL 的 API 钥。(必须)
* `SCAN_INTERVAL`: 这里以分钟为单位指定 plot 的扫描间隔。(必须)
* `/plot-N` 目录对应于 0 到 9。如果目录已挂载，则自动添加。

## 通过 K8S 使用时

1. 如果是通过 K8S 来使用的话，可以预先 push 到某个共同的私人注册表上:

```bash
$ sudo docker tag rpi-hpool-chia-miner master.local:1234/rpi-hpool-chia-miner
$ sudo docker push master.local:1234/rpi-hpool-chia-miner
```

* 需要更改 IP 地址和端口号在两行指向您的注册表。

2. 根据您的集群构成，首先修正 `deployment.yaml`

* 可能您的每个节点都连接了物理存储 (P 盘)，
  但是需要在一部分节点上执行的话设置 `nodeAffinity`。
* 我想可能是使用了私人注册表，
  在那里部署的时候可以指定 Docker 镜像来进行注册表。

3. 部署

```bash
$ kubectl create -f ./deployment.yaml
```

## 其他

* 这个仓库使用: [hpool-dev/chia-miner](https://github.com/hpool-dev/chia-miner) (v1.4.0-2)
  使用时请遵从他们的许可证。
* 在由 5+1 个树莓派和 15 个硬盘组成的 K8S 集群上运行，目前没有问题。

```
[master] <> [worker1] <> P_1, P_2, P_3
 |          [worker2] <> P_4, P_5, P_6
w/repo      [worker3] <> P_7, P_8, P_9
            ...          ...
```
