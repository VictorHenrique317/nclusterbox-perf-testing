#!/bin/bash

for i in {1..8}
do
	cd j$i
	perf report > report.txt
	cat report.txt | grep -E "Samples:|Event count" > report-filtered.txt
	cd ..
done
