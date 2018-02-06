#!/bin/bash

# read depth  # tree depth
depth=5  # temporary

width=100  # result width
height=63  # result height
dot='1'  # foreground symbol
back='_'  # background symbol
init_Y_height=16  

# calculating dots
mid=$((width / 2))
dots=''
prev_row=0
for lev in $(seq 0 $depth); do
	cur_Y_height=$((init_Y_height / 2 ** lev))
	for Y_count in $(seq 1 $((2 ** lev))); do
		echo $Y_count
		# creating Y base
		for i in $(seq 1 $cur_Y_height); do
			dots="$dots $mid;$i"
		done
		prev_row=$((prev_row + i))
		
		# creating Y antennas
		for i in $(seq 1 $cur_Y_height); do
			x=$((mid - i))
			y=$((prev_row + i))
			dots="$dots $x;$y"
			x=$((mid + i))
			dots="$dots $x;$y"
		done
		prev_row=$((prev_row + i))
	done
done

exit

# dots='20;10 30;12'  # temporary

# drawing the area
for row in $(seq 1 $height); do
	for col in $(seq 1 $width); do
		for d in $dots; do
			if [ "${col};${row}" = "$d" ]; then
				echo -en "$dot"
				continue 2
			fi
		done
		echo -en "$back"
	done
	echo
done


