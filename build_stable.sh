#!/bin/bash

export RUSTFLAGS="
    -C relocation-model=static \
    -C symbol-mangling-version=v0 \
    -C llvm-args=-fp-contract=off \
    -C llvm-args=-enable-misched \
    -C llvm-args=-enable-post-misched \
    -C llvm-args=-enable-dfa-jump-thread \
    -C link-args=-Wl,--sort-section=alignment \
    -C link-args=-Wl,-O3,--gc-sections,--as-needed \
    -C link-args=-Wl,-z,relro,-z,now,-x,-z,noexecstack,-s,--strip-all
" 

cargo update

export CARGO_TERM_COLOR=always

export JEMALLOC_SYS_DISABLE_WARN_ERROR=1

cargo +stable zigbuild -r --target "$1" -p rustfs --bins

dd if=./target/"$1"/release/rustfs of=./"$1"_module/rustfs
