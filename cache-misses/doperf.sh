#!/bin/bash

for i in {1..8}
do
    cd j$i
    perf record -e LLC-loads,LLC-load-misses ../../../nclusterbox/nclusterbox -m 1000 -j $i ../retweets-sparser > output.txt
    cd ..
done
