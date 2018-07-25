create extension postgis;
create schema ned;

drop table if exists ned.us_va_norfolk;
create table ned.us_va_norfolk ("rid" serial primary key, "rast" raster);
