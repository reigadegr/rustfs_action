setx RUSTFS_ACCESS_KEY "rfsaccess"
setx RUSTFS_SECRET_KEY "rfssecret"

setx RUSTFS_VOLUMES ".\data_rfs"
cmd /c md ".\data_rfs"

setx RUSTFS_ADDRESS ":9190"
setx RUST_LOG warn

setx RUSTFS_OBS_LOG_DIRECTORY ".\logs"  
setx RUSTFS_SINKS_FILE_PATH ".\logs"

