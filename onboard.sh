#!/bin/bash

set -e

input="$1"
CR=$(printf '\r')

while IFS=$CR read -r url
do
  filename=$(basename "$url")

  echo "--> loading $filename ..."
  wget $url
  unzip -d $filename.dir $filename

  cd $filename.dir
  for las in *.las; do
    las2ogr -i $las -o lpc.shp
    shp2pgsql -a -s 26918:4326 lpc public.lpc -f lpc.sql -W "latin1" -S
    mv lpc.sql ../lpc-$filename.sql
  done

  cd ..
  rm $filename*

  echo "finished $filename"

done < "$input"
