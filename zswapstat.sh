#!/bin/bash

if [ $UID -ne 0 ]
then
  echo You are not ROOT!
  exit 1
fi

if [ ! -e /sys/kernel/debug/zswap ]
then
  echo debugfs not mounted or zswap not used!
  exit 1
fi

zswap_pool_total_size=$(</sys/kernel/debug/zswap/pool_total_size)
zswap_stored_pages=$(</sys/kernel/debug/zswap/stored_pages)
page_size=$(getconf PAGE_SIZE)
swap_used=$(cat /proc/meminfo | awk '/SwapTotal/ { total = $2}; /SwapFree/ {swapfree = $2 }; END {print (total - swapfree) * 1024 }')

awk '/Swap/ { printf "%-15s %10d KiB (%8.2f MiB)\n", $1, $2, $2 / 1024}' /proc/meminfo
echo $swap_used | awk '{printf "%-15s %10d KiB (%8.2f MiB)\n", "Swap usage:", $1 / 1024, $1 / 1024 / 1024}'
echo $zswap_pool_total_size | awk '{printf "%-15s %10d KiB (%8.2f MiB)\n", "Mem usage:", $1 / 1024, $1 / 1024 / 1024}'
echo $zswap_stored_pages $page_size | awk '{ zswapkb =  $1 * $2 / 1024; printf "%-15s %10d KiB (%8.2f MiB)\n", "Stored:", zswapkb, zswapkb / 1024}'
echo $zswap_stored_pages $page_size $zswap_pool_total_size | awk '{if ($3==0) poolsize=1; else poolsize=$3; printf "%-15s %14.3f\n", "Comp. ratio:", $1 * $2 / poolsize}'
echo $swap_used $zswap_stored_pages $page_size | awk '{swapdisk = ($1 - $2 * $3) / 1024; printf "%-15s %10d KiB (%8.2f MiB)\n", "Swap on disk:",swapdisk, swapdisk / 1024}'
