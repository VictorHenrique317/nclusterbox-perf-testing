#!/bin/bash
rerun=false

if [[ $1 == "--rerun" ]]; then
    rerun=true
fi

iterations=550
raw_perf_results_dir="raw-perf-results"
formated_perf_results_dir="formated-perf-results"
datasets="retweets-sparser retweets-denser school"
user="victor.henrique"

rm -rf $formated_perf_results_dir

if [[ $rerun == true ]]; then
    rm -rf $raw_perf_results_dir
    mkdir $raw_perf_results_dir
    chown $user:$user $raw_perf_results_dir

    for ((i=1; i<=$iterations; i++))
    do
        echo "Iteration: $i"
        scripts/run-perf.sh $raw_perf_results_dir $user "$datasets" $i
    done
fi

mkdir $formated_perf_results_dir
chown $user:$user $formated_perf_results_dir

scripts/format-result.sh "$datasets" $raw_perf_results_dir $formated_perf_results_dir $user $iterations

python3 scripts/pearsons_r.py "$datasets" $iterations