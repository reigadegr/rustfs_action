#!/bin/bash
mkdir -p $(dirname "$0")/libs

target="$(cat staticlib.txt)"

for i in $target; do
    i="$(basename $i)"
    
    for j in $(sudo find /home/.rustup -name "$i"); do
        cp $j $(dirname "$0")/libs
    done
    
    for j in $(sudo find /usr/lib -name "$i"); do
        cp $j $(dirname "$0")/libs
    done
done
