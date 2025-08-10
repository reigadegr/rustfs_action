#!/bin/sh
MODDIR=${0%/*}
LOG=./log.txt

export RUSTFS_VOLUMES="./rustfs_workspace"  
export RUSTFS_ADDRESS=":9000"
export RUST_LOG="warn"

killall -15 rustfs; rm $LOG
chmod +x ${0%/*}/rustfs
RUST_BACKTRACE=1 nohup ./rustfs >$LOG 2>&1 &

ip="$(ifconfig | awk '/inet / && !/127.0.0.1/ && /255.255.255.0/ {print $2}')"

if [  ! -z "$(echo $ip | grep ':' )" ]; then
    ip="$(echo $ip | cut -d ':' -f2)"
fi

echo "访问$ip$RUSTFS_ADDRESS"

export MC_CONFIG_DIR="./rustfs_workspace/.mc"  
mkdir -p "$MC_CONFIG_DIR"

killall -15 mc
chmod +x ./mc
sleep 1
# 起别名
./mc alias set myminio "http://localhost$RUSTFS_ADDRESS" rustfsadmin rustfsadmin

# 创建桶
./mc mb myminio/mybucket

# 设置桶为公开访问：
./mc anonymous set public myminio/mybucket
