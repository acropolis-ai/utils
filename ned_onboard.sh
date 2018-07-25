#!/bin/bash

set -e

input="$1"
table="$2"
CR=$(printf '\r')

pg_host="35.193.81.0"
pg_user="importer"
pg_db="acropoly"

echo "--> downloading files..."
while IFS=$CR read -r url
do
  filename=$(basename "$url")

  if [[ ! $filename =~ \.zip$ ]]; then continue; fi

  echo "--> downloading $filename ..."
  wget -q $url
done < "$input"
echo "--> DONE downloading files"

echo "--> extracing zip files..."
unzip -qq \*.zip
rm -rf *.zip
echo "--> DONE extracting zip files"

echo "--> Converting rasters to pgsql..."
time raster2pgsql -b 1 -t auto -s 26918 -a -M -C *.img ned.$table > $table.sql
echo "--> DONE converting IMG -> PGSQL ..."

echo "--> loading pgsql into $table..."
time psql -h $pg_host -U $pg_user -d $pg_db -f $table.sql
echo "--> DONE loading $table"
