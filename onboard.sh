#!/bin/bash

set -e

input="$1"
CR=$(printf '\r')

while IFS=$CR read -r url
do
  filename=$(basename "$url")

  if [[ ! $filename =~ \.zip$ ]]; then continue; fi

  echo "--> loading $filename ..."
  wget -q $url
  mkdir $filename-dir
  unzip -qq -d $filename-dir $filename

  cd $filename-dir
  for las in *.las; do
    las2ogr -i $las -o lpc.shp
    shp2pgsql -a -s 26918:4326 lpc public.lpc -W "latin1" > lpc.sql
    PGPASSWORD=s6733fdq1Yes psql -h 35.193.81.0 -U importer -d acropoly -f lpc.sql >/dev/null
  done

  cd ..
  rm $filename
  rm -rf $filename-dir

  echo "--> finished $filename"

done < "$input"
