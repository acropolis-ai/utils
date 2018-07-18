create extension postgis;

drop table onboard.lpc;

create table onboard.lpc (
  gid serial,
  return_num numeric(10,0),
  angle numeric(10,0),
  intensity numeric(10,0),
  asprsclass varchar(60),
  return_tot numeric(10,0),
  gpstime numeric(10,0)
);

alter table onboard.lpc add primary key (gid);
select AddGeometryColumn('onboard', 'lpc', 'geom', '0', 'POINT', 4);
