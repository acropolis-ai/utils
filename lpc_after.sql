create table public.lpc (
  gid serial,
  elevation double precision
);
select AddGeometryColumn('public', 'lpc', 'geom', 4326, 'POINT', 2);

select 
  gid,
  st_transform(st_setsrid(st_makepoint(st_x(geom), st_y(geom)), 26918), 4326) as geom,
  st_z(geom) as elevation
into public.lpc from onboard.lpc;

create index lpc_geom_index on public.lpc using gist (geom);

drop table onboard.lpc;
