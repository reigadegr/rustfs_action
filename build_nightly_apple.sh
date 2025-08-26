#!/bin/bash

export RUSTFLAGS="
    -Z mir-opt-level=2 \
    -Z dylib-lto=yes \
    -Z inline-mir=yes \
    -Z fewer-names=yes \
    -Z box-noalias=yes \
    -Z share-generics=yes \
    -Z remap-cwd-prefix=. \
    -Z mutable-noalias=yes \
    -Z function-sections=yes \
    -Z dep-info-omit-d-target \
    -Z flatten-format-args=yes \
    -Z saturating-float-casts=yes \
    -Z mir-enable-passes=+Inline \
    -Z precise-enum-drop-elaboration=yes \
    -C relro-level=none \
    -C code-model=small \
    -C relocation-model=static \
    -C symbol-mangling-version=v0 \
    -C llvm-args=-fp-contract=off \
    -C llvm-args=-enable-misched \
    -C llvm-args=-enable-post-misched \
    -C llvm-args=-enable-dfa-jump-thread \
    -C link-args=-Wl,-dead_strip \
    -C link-args=-Wl,-S
" 

cargo update

export CARGO_TERM_COLOR=always

export JEMALLOC_SYS_DISABLE_WARN_ERROR=1

cargo +nightly build -r --target "$1" --bin "$2" -Z build-std -Z trim-paths
