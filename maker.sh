#!/bin/bash

# read depth  # tree depth
depth=5  # temporary

width=100  # result width
height=63  # result height

ones='20;10 30;12'  # temporary

# drawing the area
for row in $(seq 1 $width); do
	for col in $(seq 1 $height); do
		for d in $ones; do
			if [ "${row};${col}" = "$d" ]; then
				echo -en 1
			else
				echo -en _
			fi
		done
	done
	echo
done


