* 中文
* 日本語 (翻訳おかしかったので下部に日本語で追記しました)
* [English](https://translate.google.com/translate?sl=zh-CN&tl=en&u=https%3A%2F%2Fgithub.com%2Fydipeepo%2Frpi-hpool-chia-miner%2Fblob%2Fmain%2FREADME.md)

----

![BIG O](https://github.com/ydipeepo/nvme-mate/raw/master/doc/big-o.png)

# 在树莓派 4B 上 HPOOL Chia 挖矿

通过 Docker 或 K8S 运行 HPOOL Chia 挖矿软件。这是非官方的。
虽然省略了前提条件但是使用了 Ubuntu Server 的最新版本。

## 建造 Docker 镜像

在树莓派上 `git clone` 后运行:

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

1. 如果是通过 K8S 来使用的话，可以预先 `push` 到某个共同的私人注册表上:

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

----

# ラズパイ 4B で HPOOL Chia マイニング

Docker もしくは K8S を通して HPOOL Chia マイニングします。非公式です。
前提条件はここでは省略しますが、Ubuntu Server の最新版を使用しました。


## Docker イメージをビルド

ラズパイ上に `git clone` した後、そのラズパイ上で Docker イメージをビルドしておきます:

```bash
$ sudo docker build . -t rpi-hpool-chia-miner
```

## Docker 上で直接動かす場合

以下のコマンドでマイナーを開始します:

```bash
$ sudo docker run \
	-e API_KEY=********-****-****-****-************ \
	-e SCAN_INTERVAL=15 \
	-v /mnt/sda1:/plot-0 \
	-v /mnt/sdb1:/plot-1 \
	-it rpi-hpool-chia-miner
```

* `API_KEY`: HPOOL の API キーを指定します。(必須)
* `SCAN_INTERVAL`: プロットのスキャン間隔を分単位で指定します。(必須)
* `/plot-N` コンテナ側ディレクトリは 0 から 9 まで対応しています。
  ディレクトリが存在すれば自動で対象として読み込みます。

## K8S を通して使う場合

1. K8S を通して使用する場合、先ほどビルドしたイメージを
   どこかプライベートな Docker レジストリ上に `push` しておきます:

```bash
$ sudo docker tag rpi-hpool-chia-miner master.local:1234/rpi-hpool-chia-miner
$ sudo docker push master.local:1234/rpi-hpool-chia-miner
```

* 2 行それぞれの IP アドレス (かホスト名) とポート番号はレジストリに合わせて変更してください。
  (`master.local` と `1234` という部分)

2. クラスター構成に合わせてデプロイメントマニフェスト (`deployment.yaml`) を修正してください。

* `env` 以下の `API_KEY` にあなたの API キーを設定してください。
* 各ノードにはプロット含むハードディスクが接続されていると思いますが、
  もし一部のノードでのみ実行する必要がある場合は `nodeAffinity` の部分を修正してください。

3. クラスターにデプロイする:

```bash
$ kubectl create -f ./deployment.yaml
```

## ほか

* このリポジトリは [hpool-dev/chia-miner](https://github.com/hpool-dev/chia-miner) (v1.4.0-2) を使っています。
  使用時は彼らのライセンスに従ってください。
