#!/bin/bash

read depth1  # tree depth

depth=$((depth1 - 1))
width=100  # result width
height=63  # result height
dot='1'  # foreground symbol
back='_'  # background symbol
init_Y_height=16  

# calculating dots
cntr=$((width / 2 + 1))
dots=''
y=0
mids=$cntr

for lev in $(seq 0 $depth); do  # iterating levels
	cur_Y_height=$((init_Y_height / 2 ** lev))
	shift_count=$((2 ** lev/2))  # number of Y-base shifts on current level to each side
	shift_len=$((2 ** (5 - lev + 1)))  # size of the shift
	shift_sum=$((shift_len / 2))  # init shift for total shift length
	for i in $(seq 1 $shift_count); do
		mids="$mids $((cntr - shift_sum)) $((cntr + shift_sum))"
		shift_sum=$((shift_sum + shift_len))
	done

	for Y_count in $(seq 1 $((2 ** lev))); do  # creating needed number of Y-s
		# creating Y base
		for i in $(seq 1 $((cur_Y_height))); do
			y_cur=$((y + i))
			for mid in $mids; do
				dots="$dots $mid;$y_cur"
			done
		done
		# creating Y antennas
		for i in $(seq 1 $((cur_Y_height))); do  # 
			y_cur=$((y + i + cur_Y_height))
			for mid in $mids; do
				x=$((mid - i))
				dots="$dots $x;$y_cur"
				x=$((mid + i))
				dots="$dots $x;$y_cur"
			done
		done
	done
	mids=''  # new mids on th next level
	y=$((y + 2 * cur_Y_height))
done

# drawing the area
for row in $(seq 1 $height | tac); do
	r=$(printf "$back%.0s" $(seq 1 $width))
	for x in $(echo " $dots " | \
			   egrep -o "[0-9]+;${row} " | \
			   awk -F\; '{print $1-2}'); do  # all X-coord in current row
		r=$(echo $r | sed "s/^\(.\{$x\}\).\(.\+\)$/\1${dot}\2/g")
	done
	echo $r
done

