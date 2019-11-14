#!/bin/bash

if [ $UID -ne 0 ]
then
  echo You are not ROOT!
  exit 1
fi

zswap_pool_total_size=$(</sys/kernel/debug/zswap/pool_total_size)
zswap_stored_pages=$(</sys/kernel/debug/zswap/stored_pages)
page_size=$(getconf PAGE_SIZE)

echo "Pool size:         $(echo $zswap_pool_total_size | awk '{print $1 / 1024 / 1024}')MiB"
echo "Stored:            $(echo $zswap_stored_pages $page_size | awk '{print $1 * $2 / 1024 / 1024}')MiB"
echo Compression level: $(echo $zswap_stored_pages $page_size $zswap_pool_total_size | awk '{print $1 * $2 / $3}')
