#!/bin/bash

set -e

input="$1"
CR=$(printf '\r')

while IFS=$CR read -r url
do
  filename=$(basename "$url")

  if [[ ! $filename =~ \.zip$ ]]; then continue; fi

  echo "--> loading $filename ..."
  wget $url
  mkdir $filename-dir
  unzip -d $filename-dir $filename

  cd $filename-dir
  for las in *.las; do
    las2ogr -i $las -o lpc.shp
    shp2pgsql -a -s 26918:4326 lpc public.lpc -W "latin1" > ../lpc-$filename.sql
  done

  cd ..
  rm -rf $filename*

  echo "finished $filename"

done < "$input"