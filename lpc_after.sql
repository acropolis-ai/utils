drop table if exists public.lpc;
create table public.lpc (
  elevation integer
);
select AddGeometryColumn('public', 'lpc', 'geom', 3857, 'POINT', 2);

insert into public.lpc (elevation, geom)
select
  (st_z(geom) * 100) as elev_cm,
  st_transform(st_setsrid(st_makepoint(st_x(geom), st_y(geom)), 26918), 3857) as geom
from onboard.lpc;

create index lpc_geom_index on public.lpc using gist (geom);
vacuum public.lpc;
cluster public.lpc using lpc_geom_index;
analyze public.lpc;

--drop table onboard.lpc;
