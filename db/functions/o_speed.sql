CREATE OR REPLACE FUNCTION o_speed(vehicle_type character varying, medium_type character varying, path_geom geometry, default_cost double precision)
  RETURNS double precision AS
$BODY$SELECT
(
CASE
when $1 = 'foot' AND $2 = 'road' then st_length(Geography(ST_Transform($3,4326))) / 30000
when $1 = 'donkey' AND $2 = 'road' then st_length(Geography(ST_Transform($3,4326))) / 30000
when $1 = 'oxcart' AND $2 = 'road' then st_length(Geography(ST_Transform($3,4326))) / 12000
when $1 = 'wagon' AND $2 = 'road' then st_length(Geography(ST_Transform($3,4326))) / 30000
when $1 = 'porter' AND $2 = 'road' then st_length(Geography(ST_Transform($3,4326))) / 20000
when $1 = 'horse' AND $2 = 'road' then st_length(Geography(ST_Transform($3,4326))) / 56000
when $1 = 'privateroutine' AND $2 = 'road' then st_length(Geography(ST_Transform($3,4326))) / 36000
when $1 = 'privateaccelerated' AND $2 = 'road' then st_length(Geography(ST_Transform($3,4326))) / 50000
when $1 = 'fastcarriage' AND $2 = 'road' then st_length(Geography(ST_Transform($3,4326))) / 67000
when $1 = 'carriage' AND $2 = 'road' then st_length(Geography(ST_Transform($3,4326))) / 36000
when $1 = 'horserelay' AND $2 = 'road' then st_length(Geography(ST_Transform($3,4326))) / 250000
when $1 = 'rapidmarch' AND $2 = 'road' then st_length(Geography(ST_Transform($3,4326))) / 60000
when $1 = 'rapidmarch' AND $2 = 'upstream' then st_length(Geography(ST_Transform($3,4326))) / 50000
when $1 = 'rapidmarch' AND $2 = 'downstream' then st_length(Geography(ST_Transform($3,4326))) / 120000
when $2 = 'overseas' then $4
when $2 = 'coastal' then $4
when $2 = 'ferry' then $4
when $2 = 'downstream' then $4
when $2 = 'upstream' then $4
when $2 = 'fastdown' then $4
when $2 = 'fastup' then $4
when $2 = 'slowover' then $4
when $2 = 'slowcoast' then $4
when $2 = 'dayslow' then $4
when $2 = 'dayfast' then $4
else 99999
end
)
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
