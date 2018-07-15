create table public.lpc (
  gid serial,
  return_num numeric(10,0),
  angle numeric(10,0),
  intensity numeric(10,0),
  asprsclass varchar(60),
  return_tot numeric(10,0),
  gpstime numeric(10,0)
);
alter table public.lpc add primary key (gid);
select AddGeometryColumn('public','lpc','geom','4326','POINT',4);
create index on public.lpc using gist (geom);
