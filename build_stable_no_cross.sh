#!/bin/bash

export RUSTFLAGS="
    -C default-linker-libraries \
    -C symbol-mangling-version=v0 \
    -C llvm-args=-fp-contract=off \
    -C llvm-args=-enable-misched \
    -C llvm-args=-enable-post-misched \
    -C llvm-args=-enable-dfa-jump-thread \
    -C link-args=-Wl,--sort-section=alignment \
    -C link-args=-Wl,-O1,--gc-sections,--as-needed \
    -C link-args=-Wl,-z,relro,-z,now,-x,-z,noexecstack,-s,--strip-all
" 

cargo update

export CARGO_TERM_COLOR=always

export JEMALLOC_SYS_DISABLE_WARN_ERROR=1

cargo +stable build -r --target "$1" -p rustfs --bins

cp -af ./target/release/rustfs.exe ./"$1"_module/rustfs.exe
