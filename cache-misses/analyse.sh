#!/bin/bash

for j in {1..8}
	do
	# Change to the j directory
	cd j$j

	# Extract the LLC-loads and LLC-load-misses event counts from the report-filtered.txt file
	loads=$(grep -A 1 'LLC-loads' report-filtered.txt | grep 'Event count (approx.):' | awk '{print $5}')
	misses=$(grep -A 1 'LLC-load-misses' report-filtered.txt | grep 'Event count (approx.):' | awk '{print $5}')

	# Calculate the percentage of misses
	percentage=$(echo "scale=2; $misses / ($loads + $misses) * 100" | bc)

	# save
	echo "$percentage" > percentage-misses.txt

	# Change back to the parent directory
	cd ..
done
