#!/system/bin/sh
MODDIR=${0%/*}
LOG=$MODDIR/log.txt

wait_until_login() {
    # in case of /data encryption is disabled
    while [ "$(getprop sys.boot_completed)" != "1" ]; do sleep 1; done
    # we doesn't have the permission to rw "/sdcard" before the user unlocks the screen
    until [ -d /sdcard/Android ]; do sleep 1; done
}

wait_until_login

export RUSTFS_VOLUMES="/storage/emulated/0/Android/rustfs"  
export RUSTFS_ADDRESS=":9000"
export RUST_LOG="warn"

killall -15 rustfs; rm $LOG
chmod +x ${0%/*}/rustfs
RUST_BACKTRACE=1 nohup $MODDIR/rustfs >$LOG 2>&1 &

ip="$(ifconfig | awk '/inet / && !/127.0.0.1/ && /255.255.255.0/ {print $2}')"

if [  ! -z "$(echo $ip | grep ':' )" ]; then
    ip="$(echo $ip | cut -d ':' -f2)"
fi
sed -i '/description=/d' $MODDIR/module.prop
echo "description=访问$ip$RUSTFS_ADDRESS" >> $MODDIR/module.prop

export MC_CONFIG_DIR="/sdcard/Android/rustfs/.mc"  
mkdir -p "$MC_CONFIG_DIR"

killall -15 mc
chmod +x $MODDIR/mc
sleep 1
# 起别名
$MODDIR/mc alias set myminio http://localhost:9000 rustfsadmin rustfsadmin

# 创建桶
$MODDIR/mc mb myminio/mybucket

# 设置桶为公开访问：
$MODDIR/mc anonymous set public myminio/mybucket
