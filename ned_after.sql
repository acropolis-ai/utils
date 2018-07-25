create index on ned.us_va_norfolk using gist (st_convexhull(rast));
select AddRasterConstraints('ned', 'us_va_norfolk', 'rast', true, true true, true, true, true, false, true, true, true, true, true);
vacuum analyze ned.us_va_norfolk;
