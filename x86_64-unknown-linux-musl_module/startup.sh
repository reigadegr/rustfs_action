#!/bin/sh
MODDIR=${0%/*}
LOG=$MODDIR/log.txt

export RUSTFS_VOLUMES="$MODDIR/nas"  
export RUSTFS_ADDRESS="0.0.0.0:9000"
export RUST_LOG="warn"

export RUSTFS_ACCESS_KEY="rfsaccess"
export RUSTFS_SECRET_KEY="rfssecret"

killall -15 rustfs; rm $LOG
chmod +x ${0%/*}/rustfs
RUST_BACKTRACE=1 nohup $MODDIR/rustfs >$LOG 2>&1 &

ip="$(ifconfig | awk '/inet / && !/127.0.0.1/ && /255.255.255.0/ {print $2}')"

if [  ! -z "$(echo $ip | grep ':' )" ]; then
    ip="$(echo $ip | cut -d ':' -f2)"
fi

port="$(echo $RUSTFS_ADDRESS | cut -d ':' -f2)"
echo "访问$ip:$port"

export MC_CONFIG_DIR="$MODDIR/nas/.mc"  
mkdir -p "$MC_CONFIG_DIR"

killall -15 mc
chmod +x $MODDIR/mc
sleep 1

# 起别名
$MODDIR/mc alias set myrustfs "http://$RUSTFS_ADDRESS" "$RUSTFS_ACCESS_KEY" "$RUSTFS_SECRET_KEY"

# 创建桶
$MODDIR/mc mb myrustfs/mybucket

# 设置桶为公开访问：
$MODDIR/mc anonymous set public myrustfs/mybucket
