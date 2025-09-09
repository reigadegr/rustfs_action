#!/bin/bash

export RUSTFLAGS="
    -C relro-level=full \
    -C code-model=small \
    -C default-linker-libraries \
    -C target-feature=+crt-static \
    -C symbol-mangling-version=v0 \
    -C llvm-args=-fp-contract=off \
    -C llvm-args=-enable-misched \
    -C llvm-args=-enable-post-misched \
    -C llvm-args=-enable-dfa-jump-thread \
    -C link-args=-Wl,--sort-section=alignment \
    -C link-args=-Wl,-O2,--gc-sections,--as-needed \
    -C link-args=-Wl,-x,-s,--strip-all
" 

cargo update

export CARGO_TERM_COLOR=always

export JEMALLOC_SYS_DISABLE_WARN_ERROR=1

cargo +stable build -r --target "$1" --bin "$2"
