setx RUSTFS_ACCESS_KEY "rfsaccess"
setx RUSTFS_SECRET_KEY "rfssecret"

setx RUSTFS_VOLUMES "E:\miniIO\data_rfs"
setx RUSTFS_ADDRESS "0.0.0.0:9000"
setx RUST_LOG warn

setx RUSTFS_OBS_LOG_DIRECTORY "E:\miniIO\logs"  
setx RUSTFS_SINKS_FILE_PATH "E:\miniIO\logs"

taskkill /F /IM rustfs.exe
.\rustfs.exe
