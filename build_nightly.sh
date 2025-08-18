#!/bin/bash

export RUSTFLAGS="
    -Z validate-mir \
    -Z verify-llvm-ir \
    -Z mir-opt-level=1 \
    -Z share-generics=yes \
    -Z remap-cwd-prefix=. \
    -Z function-sections=yes \
    -Z dep-info-omit-d-target \
    -C default-linker-libraries \
    -C symbol-mangling-version=v0 \
    -C llvm-args=-fp-contract=off \
    -C llvm-args=-enable-misched \
    -C llvm-args=-enable-branch-hint \
    -C llvm-args=-enable-post-misched \
    -C llvm-args=-enable-dfa-jump-thread \
    -C link-args=-fomit-frame-pointer \
    -C link-args=-Wl,-O1,--gc-sections,--as-needed \
    -C link-args=-Wl,-z,relro,-z,now,-x,-z,noexecstack,-s,--strip-all
" 

rm -rf Cargo.lock

export CARGO_TERM_COLOR=always

export JEMALLOC_SYS_DISABLE_WARN_ERROR=1

cargo +nightly zigbuild -r --target "$1" -p rustfs --bins -Z build-std -Z trim-paths

dd if=./target/"$1"/release/rustfs of=./"$1"_module/rustfs
