#!/bin/bash

iszram=$(lsmod|grep zram|wc -l)
if [ $iszram -eq 0 ]
then
  modprobe zram
fi
zramdev=$(zramctl -s 1G -t 4 -a lz4hc -f)
if [ ! -z $zramdev ]
then
  mkswap /dev/zram0
  swapon -p 5 /dev/zram0
else
  echo zram-disk not created!
fi