cd /hpool-chia-miner

#
# 制作 config.yaml 文件
#

echo "[MINER] 配置挖矿 config.yaml..."

if [[ -z "${API_KEY}" ]]; then
	>&2 echo "[MINER] 未定义 API_KEY。"
	exit 2
fi

echo -n                                 > config.yaml
echo "token: \"\""                     >> config.yaml
echo "path:"                           >> config.yaml

NUM_MOUNTS=0
for i in {0..9}; do
	if [[ -d "/plot-${i}" ]]; then
		echo "- /plot-${i}"            >> config.yaml
		((NUM_MOUNTS+=1))
	fi
done
if [ "$NUM_MOUNTS" -eq "0" ]; then
	>&2 echo "[MINER] 未装入任何 P 盘目录。"
	exit 2
fi
unset NUM_MOUNTS

echo "minerName: \"$(hostname)\""      >> config.yaml
echo "apiKey: \"${API_KEY}\""          >> config.yaml
echo "cachePath: \"\""                 >> config.yaml
echo "deviceId: \"\""                  >> config.yaml
echo "extraParams: {}"                 >> config.yaml
echo "log:"                            >> config.yaml
echo "  lv: info"                      >> config.yaml
echo "  path: ./log/"                  >> config.yaml
echo "  name: miner.log"               >> config.yaml
echo "url:"                            >> config.yaml
echo "  info: \"\""                    >> config.yaml
echo "  submit: \"\""                  >> config.yaml
echo "  line: \"\""                    >> config.yaml
echo "  ws: \"\""                      >> config.yaml
echo "scanPath: true"                  >> config.yaml
echo "scanMinute: ${SCAN_INTERVAL}"    >> config.yaml
echo "debug: \"\""                     >> config.yaml
echo "language: cn"                    >> config.yaml
echo "multithreadingLoad: true"        >> config.yaml

#
# 开始 HPOOL 挖矿软件
#

echo "[MINER] 启动挖矿..."
while true; do
	./hpool-chia-miner-linux-arm
	echo "[MINER] 意外终止，将在 5 分钟后恢复..."
	sleep 60
done
