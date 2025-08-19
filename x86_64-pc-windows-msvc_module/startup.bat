setx RUSTFS_ACCESS_KEY "rfsaccess"
setx RUSTFS_SECRET_KEY "rfssecret"

setx RUSTFS_VOLUMES "./nas"
setx RUSTFS_ADDRESS "0.0.0.0:9000"
setx RUST_LOG warn

taskkill /F /IM rustfs.exe
./rustfs.exe
