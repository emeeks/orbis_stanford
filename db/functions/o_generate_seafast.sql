CREATE OR REPLACE FUNCTION o_generate_seafast(month integer, source character varying, target character varying, note character varying)
  RETURNS void AS
$BODY$INSERT INTO o_fastsea (source, target, slabel, tlabel, total, the_geom, month, note)

SELECT
source, target, s_label.label as slabel, t_label.label as tlabel, 
(SELECT SUM(calcost)

FROM 

(SELECT (  case
when o_mesh.direction = 'N' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.n * 1852)
when o_mesh.direction = 'NE' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.ne * 1852)
when o_mesh.direction = 'E' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.e * 1852)
when o_mesh.direction = 'SE' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.se * 1852)
when o_mesh.direction = 'S' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.s * 1852)
when o_mesh.direction = 'SW' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.sw * 1852)
when o_mesh.direction = 'W' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.w * 1852)
when o_mesh.direction = 'NW' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.nw * 1852)
when o_mesh.direction = 'A' then o_mesh.cost
when o_mesh.direction = 'PT' then o_mesh.cost
else 3
end)::double precision / 24 as calcost FROM shortest_path('
SELECT DISTINCT

o_mesh.gid as id,
o_mesh.source::integer,
o_mesh.target::integer,
(  case
when o_mesh.direction = ''N'' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.n * 1852)
when o_mesh.direction = ''NE'' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.ne * 1852)
when o_mesh.direction = ''E'' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.e * 1852)
when o_mesh.direction = ''SE'' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.se * 1852)
when o_mesh.direction = ''S'' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.s * 1852)
when o_mesh.direction = ''SW'' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.sw * 1852)
when o_mesh.direction = ''W'' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.w * 1852)
when o_mesh.direction = ''NW'' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.nw * 1852)
when o_mesh.direction = ''A'' then o_mesh.cost
when o_mesh.direction = ''PT'' then o_mesh.cost
else 3
end)::double precision as cost,
o_mesh.the_geom

FROM
o_mesh

LEFT JOIN o_ref ON o_ref.mesh_id = o_mesh.source AND o_ref.month = '||$1||'
LEFT JOIN o_fast_ave AS ship ON ship.gid = o_ref.rose_id
LEFT JOIN roses ON roses.gid = ship.gid
LEFT JOIN wave ON wave.month = '||$1||' AND ST_Intersects(o_mesh.the_geom, wave.the_geom)


WHERE

roses.month = '||$1||'

AND

(wave.gid IS NULL

OR

o_mesh.source > 50000)

AND

o_mesh.month IN (0,'||$1||')',
source,target,true,false)


LEFT JOIN o_mesh ON o_mesh.gid = edge_id
LEFT JOIN o_ref ON o_ref.mesh_id = o_mesh.source AND o_ref.month = $1
LEFT JOIN o_fast_ave AS ship ON ship.gid = o_ref.rose_id
LEFT JOIN roses ON roses.gid = ship.gid


) as subquery

) as total,
(SELECT ST_UNION(calgeom)

FROM 

(SELECT o_mesh.the_geom as calgeom FROM shortest_path('
SELECT DISTINCT

o_mesh.gid as id,
o_mesh.source::integer,
o_mesh.target::integer,
(  case
when o_mesh.direction = ''N'' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.n * 1852)
when o_mesh.direction = ''NE'' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.ne * 1852)
when o_mesh.direction = ''E'' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.e * 1852)
when o_mesh.direction = ''SE'' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.se * 1852)
when o_mesh.direction = ''S'' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.s * 1852)
when o_mesh.direction = ''SW'' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.sw * 1852)
when o_mesh.direction = ''W'' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.w * 1852)
when o_mesh.direction = ''NW'' then st_length(Geography(ST_Transform(o_mesh.the_geom,4326))) / (ship.nw * 1852)
when o_mesh.direction = ''A'' then o_mesh.cost
when o_mesh.direction = ''PT'' then o_mesh.cost
else 3
end)::double precision as cost,
o_mesh.the_geom

FROM
o_mesh

LEFT JOIN o_ref ON o_ref.mesh_id = o_mesh.source AND o_ref.month = '||$1||'
LEFT JOIN o_fast_ave AS ship ON ship.gid = o_ref.rose_id
LEFT JOIN roses ON roses.gid = ship.gid
LEFT JOIN wave ON wave.month = '||$1||' AND ST_Intersects(o_mesh.the_geom, wave.the_geom)


WHERE

roses.month = '||$1||'

AND

(wave.gid IS NULL

OR

o_mesh.source > 50000)


AND

o_mesh.month IN (0,'||$1||')',
source,target,true,false)


LEFT JOIN o_mesh ON o_mesh.gid = edge_id
LEFT JOIN o_ref ON o_ref.mesh_id = o_mesh.source AND o_ref.month = $1
LEFT JOIN o_fast_ave AS ship ON ship.gid = o_ref.rose_id
LEFT JOIN roses ON roses.gid = ship.gid


) as subquery

) as the_geom,
$1,
$4

FROM

less_to_less

LEFT JOIN o_sites as s_label on s_label.objectid = source
LEFT JOIN o_sites as t_label on t_label.objectid = target

WHERE

s_label.label = $2
AND
t_label.label = $3

ORDER BY
s_label.label, t_label.label


$BODY$
  LANGUAGE sql VOLATILE
  COST 100;