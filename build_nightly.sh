#!/bin/bash

export RUSTFLAGS="
    -Z validate-mir \
    -Z verify-llvm-ir \
    -Z mir-opt-level=2 \
    -Z dylib-lto=yes \
    -Z inline-mir=yes \
    -Z share-generics=yes \
    -Z remap-cwd-prefix=. \
    -Z function-sections=yes \
    -Z dep-info-omit-d-target \
    -Z flatten-format-args=yes \
    -Z mir-enable-passes=+Inline \
    -C lto=fat \
    -C relro-level=full \
    -C code-model=small \
    -C embed-bitcode=yes \
    -C relocation-model=static \
    -C symbol-mangling-version=v0 \
    -C llvm-args=-fp-contract=off \
    -C llvm-args=-enable-misched \
    -C llvm-args=-enable-post-misched \
    -C llvm-args=-enable-dfa-jump-thread \
    -C link-args=-Wl,--sort-section=alignment \
    -C link-args=-Wl,-O3,--gc-sections,--as-needed \
    -C link-args=-Wl,-x,-z,noexecstack,-s,--strip-all
" 


rm rust-toolchain.toml || true

cargo update

export CARGO_TERM_COLOR=always

export JEMALLOC_SYS_DISABLE_WARN_ERROR=1

cargo +nightly zigbuild -r --target "$1" -p rustfs --bins -Z build-std -Z trim-paths

dd if=./target/"$1"/release/rustfs of=./"$1"_module/rustfs
