#!/bin/bash
export RUSTFLAGS="
    -Z remap-cwd-prefix=. \
    -Z dep-info-omit-d-target \
    -Z merge-functions=aliases \
    -C llvm-args=-enable-ml-inliner=release \
    -C llvm-args=-inliner-interactive-include-default \
    -C llvm-args=-ml-inliner-model-selector=arm64-mixed \
    -C llvm-args=-ml-inliner-skip-policy=if-caller-not-cold \
    -C link-args=-fomit-frame-pointer \
    -C llvm-args=-mergefunc-use-aliases \
    -C llvm-args=-enable-shrink-wrap=1 \
    -C llvm-args=-enable-gvn-hoist \
    -C llvm-args=-enable-loop-versioning-licm \
    -C link-args=-Wl,-O3,--gc-sections,--as-needed \
    -C link-args=-Wl,-z,norelro,-x,-s,--strip-all,-z,now
" 

rm -rf Cargo.lock

export CARGO_TERM_COLOR=always

cargo +nightly zigbuild -r --target "$1" -p rustfs --bins -Z build-std -Z trim-paths

mkdir -p output

dd if="$(dirname "$0")"/target/aarch64-unknown-linux-musl/release/rustfs of="$(dirname "$0")"/output/rustfs
