#!/bin/bash

case "$1" in
  aarch64-*)
    EXTRA_LLVM="arm64-mixed"
    ;;
  x86_64-*)
    EXTRA_LLVM="x86_64-mixed"
    ;;
  *)
    EXTRA_LLVM=""
    ;;
esac

export RUSTFLAGS="
    -C default-linker-libraries \
    -Z remap-cwd-prefix=. \
    -Z dep-info-omit-d-target \
    -C llvm-args=-enable-ipra \
    -C llvm-args=-enable-misched \
    -C llvm-args=-enable-gvn-hoist \
    -C llvm-args=-hot-cold-split=true \
    -C llvm-args=-aggressive-ext-opt \
    -C llvm-args=-enable-post-misched \
    -C llvm-args=-enable-shrink-wrap=1 \
    -C llvm-args=-mergefunc-use-aliases \
    -C llvm-args=-enable-dfa-jump-thread \
    -C llvm-args=-enable-loopinterchange \
    -C llvm-args=-extra-vectorizer-passes \
    -C llvm-args=-enable-ml-inliner=release \
    -C llvm-args=-enable-loop-unroll-and-jam \
    -C llvm-args=-enable-loop-versioning-licm \
    -C llvm-args=-regalloc-enable-advisor=release \
    -C llvm-args=-enable-ext-tsp-block-placement \
    -C llvm-args=-ml-inliner-skip-policy=if-caller-not-cold \
    -C llvm-args=-ml-inliner-model-selector=${EXTRA_LLVM} \
    -C llvm-args=-enable-scalable-autovec-in-streaming-mode \
    -C link-args=-fomit-frame-pointer \
    -C link-args=-Wl,-O3,--gc-sections,--as-needed \
    -C link-args=-Wl,-z,norelro,-x,-s,--strip-all
" 

rm -rf Cargo.lock

export CARGO_TERM_COLOR=always

export JEMALLOC_SYS_DISABLE_WARN_ERROR=1

cargo +nightly zigbuild -r --target "$1" -p rustfs --bins -Z build-std -Z trim-paths

dd if=./target/"$1"/release/rustfs of=./"$1"_module/rustfs
