#!/bin/bash

# Generate the data file for gnuplot
mkdir -p plot
for i in {1..8}
do
    percentage=$(cat j$i/mean-percentage-misses.txt)
    echo "$i $percentage" >> plot/data.txt
done

# Generate the gnuplot script
cat << EOF > plot/plot.gp
set terminal png size 800,600
set output 'graph.png'
set xlabel 'j'
set ylabel 'Mean percentage of misses'
plot 'plot/data.txt' using 1:2 with points pointtype 7 pointsize 2 title 'Misses'
EOF

# Run gnuplot to generate the graph
gnuplot plot/plot.gp
mv graph.png plot/graph.png
