CREATE OR REPLACE FUNCTION o_routing_shortest(IN source integer, IN target integer, IN month integer, IN vehicle character varying, IN mode character varying)
  RETURNS TABLE(source character varying, target character varying, source_id integer, target_id integer, source_rank integer, target_rank integer, length numeric, duration numeric, expense_wagon numeric, expense_donkey numeric, expense_passenger numeric, gid integer, type character varying, the_geom geometry) AS
$BODY$
SELECT

s.label as source,
t.label as target,
s.objectid as source_id,
t.objectid as target_id,
s.rank as source_rank,
t.rank as target_rank,
(st_length(Geography(ST_Transform(o_routing.the_geom,4326))) / 1000)::numeric(10,3) as length,
(o_speed($4,o_routing.type,o_routing.the_geom,o_routing.cost) + o_alt_adjust($4,o_routing.restricted))::numeric(10,3) as duration,
o_expense('wagon',o_routing.type,o_routing.the_geom,o_routing.cost)::numeric(10,3) as expense_wagon,
o_expense('donkey',o_routing.type,o_routing.the_geom,o_routing.cost)::numeric(10,3) as expense_donkey,
o_expense('carriage',o_routing.type,o_routing.the_geom,o_routing.cost)::numeric(10,3) as expense_passenger,
o_routing.gid,
o_routing.type,
o_routing.the_geom

FROM

shortest_path('
SELECT DISTINCT ON (source,target)
gid as id,
source::integer,
target::integer,
st_length(Geography(ST_Transform(o_routing.the_geom,4326))) as cost
FROM
o_routing WHERE month IN(0,'||$3||')
AND 
('''||$5||''' LIKE (''%''||type||''%''))
AND (restricted NOT LIKE ''%''||type||''%'' OR restricted IS NULL) 
ORDER BY
source,
target,
st_length(Geography(ST_Transform(o_routing.the_geom,4326)))
',$1,$2,true,false)
LEFT JOIN o_routing ON o_routing.gid = edge_id
LEFT JOIN o_sites as s ON s.objectid = o_routing.source
LEFT JOIN o_sites as t ON t.objectid = o_routing.target

WHERE
o_routing.gid IS NOT NULL
$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;