#!/bin/bash

echo "	Running perf..."

raw_perf_results_dir=$1
user=$2
datasets=$3
iteration=$4

mkdir $raw_perf_results_dir/$iteration
chown $user:$user $raw_perf_results_dir/$iteration

for dataset in $datasets
do
	echo "		Dataset: $dataset"
	for i in {1..4}
		do
		echo "		===> -j=$i"

		output_file=$raw_perf_results_dir/$iteration/$dataset-result-j$i.txt
		additional_params=""

		if [[ $dataset == "school" ]]; then
			additional_params="--b"
		fi

		perf stat -o $output_file -e branch-instructions,branch-misses,bus-cycles,cache-misses,cache-references,cpu-cycles,instructions,ref-cycles,L1-dcache-load-misses,L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses,LLC-load-misses,LLC-loads,LLC-store-misses,LLC-stores,branch-load-misses,branch-loads,dTLB-load-misses,dTLB-loads,dTLB-store-misses,dTLB-stores,iTLB-load-misses,iTLB-loads,node-load-misses,node-loads,node-store-misses,node-stores nclusterbox -v2 -m10000 $additional_params -j$i datasets/$dataset -o /dev/null > temp-log.txt
		
		selection_time=$(grep "Explanatory power maximization time:" temp-log.txt | awk '{print $5}' | tr -d 's')
		rm temp-log.txt
		echo "explanatory-power-maximization-time    "$selection_time >> $output_file

		chown $user:$user $output_file
	done
done