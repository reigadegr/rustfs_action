#!/bin/bash
mkdir -p $(dirname "$0")/libs

target="$(cat staticlib.txt)"

for i in $target; do
    cp $i $(dirname "$0")/libs
done
