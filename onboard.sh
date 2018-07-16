#!/bin/bash

set -e

input="$1"
CR=$(printf '\r')

pg_host="35.193.81.0"
pg_user="importer"
pg_db="acropoly"

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
    time las2ogr -i $las -o lpc.shp
    time shp2pgsql -a -D lpc public.lpc -W "latin1" > lpc.sql.bin
    time psql -h $pg_host -U $pg_user -d $pg_db < lpc.sql.bin
  done

  cd ..
  rm $filename
  rm -rf $filename-dir

  echo "--> finished $filename"

done < "$input"
