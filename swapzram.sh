#!/bin/bash

if [ $UID -ne 0 ]
then
  echo You are not ROOT!
  exit 1
fi

iszram=$(lsmod|grep zram|wc -l)
if [ $iszram -eq 0 ]
then
  modprobe zram
fi
zramdev=$(zramctl -s 1G -t 4 -a lz4hc -f)
if [ ! -z $zramdev ]
then
  mkswap $zramdev
  swapon -d -p 5 $zramdev
else
  echo zram-disk not created!
fi