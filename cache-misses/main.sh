#!/bin/bash

# Set the number of iterations
iterations=30

# Create an array to store the sum of percentage-misses values for each value of j
sums=(0 0 0 0 0 0 0 0)
for i in $(seq 1 8)
do
	rm -rf j$i
	mkdir j$i
done

# Perform the desired number of iterations
for i in $(seq 1 $iterations)
do
    # Run the doperf.sh, extract.sh, and analyse.sh scripts
    echo $i
    ./doperf.sh
    ./extract.sh
    ./analyse.sh

    # Add the percentage-misses values to the sums array
    for j in {1..8}
    do
        percentage=$(cat j$j/percentage-misses.txt)
        sums[$((j-1))]=$(echo "${sums[$((j-1))]} + $percentage" | bc)
    done
done

# Calculate the mean percentage-misses values for each value of j
for j in {1..8}
do
    mean=$(echo "scale=2; ${sums[$((j-1))]} / $iterations" | bc)
    echo "$mean" > j$j/mean-percentage-misses.txt
done

# Run the modified plot.sh script to plot the mean values
./plot.sh
