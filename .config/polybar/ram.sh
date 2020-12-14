#!/bin/bash

#NR : line number
total=$(free -k | awk 'NR==2 {print $2}')
available=$(free -k | awk 'NR==2 {print $7}')
used=$(echo $total $available | awk '{print $1 - $2}')
#0.f take 0 nums after . and round it
percentage_used=$(echo $used $total | awk '{printf("%.0f", $1 / $2 * 100)}')
percentage_used=$(expr $percentage_used) 


if [[ $percentage_used -gt 70 ]]; then
  echo "%{F#ff0000}%{F-}  $percentage_used %"
elif [[ $percentage_used -gt 50 ]]; then
  echo "%{F#ffff00}%{F-}  $percentage_used %"
else
  echo "%{F#008700}%{F-}  $percentage_used %"
fi

