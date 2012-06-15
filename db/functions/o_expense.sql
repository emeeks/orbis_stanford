CREATE OR REPLACE FUNCTION o_expense(vehicle_type character varying, medium_type character varying, path_geom geometry, default_cost double precision)
  RETURNS double precision AS
$BODY$SELECT
(
CASE
when $1 = 'foot' AND $2 = 'road' then (st_length(Geography(ST_Transform($3,4326)))) * .000028
when $1 = 'donkey' AND $2 = 'road' then (st_length(Geography(ST_Transform($3,4326)))) * .000028
when $1 = 'oxcart' AND $2 = 'road' then (st_length(Geography(ST_Transform($3,4326)))) * .000035
when $1 = 'wagon' AND $2 = 'road' then (st_length(Geography(ST_Transform($3,4326)))) * .000035
when $1 = 'porter' AND $2 = 'road' then (st_length(Geography(ST_Transform($3,4326)))) * .000028
when $1 = 'horse' AND $2 = 'road' then (st_length(Geography(ST_Transform($3,4326)))) * .00135
when $1 = 'privateroutine' AND $2 = 'road' then (st_length(Geography(ST_Transform($3,4326)))) * .00135
when $1 = 'privateaccelerated' AND $2 = 'road' then (st_length(Geography(ST_Transform($3,4326)))) * .00135
when $1 = 'fastcarriage' AND $2 = 'road' then (st_length(Geography(ST_Transform($3,4326)))) * .00135
when $1 = 'carriage' AND $2 = 'road' then (st_length(Geography(ST_Transform($3,4326)))) * .00135
when $1 = 'horserelay' AND $2 = 'road' then (st_length(Geography(ST_Transform($3,4326)))) * .00135
when $1 = 'rapidmarch' AND $2 = 'road' then (st_length(Geography(ST_Transform($3,4326)))) * .000028

when $1 IN ('donkey', 'foot', 'wagon', 'rapidmarch','oxcart', 'porter') AND $2 IN ('upstream', 'fastup') then (st_length(Geography(ST_Transform($3,4326)))) * .0000034
when $1 IN ('horse', 'carriage', 'privateroutine', 'privateaccelerated', 'fastcarriage', 'horserelay') AND $2 IN ('upstream', 'fastup') then (st_length(Geography(ST_Transform($3,4326)))) * .00172
when $1 IN ('donkey', 'foot', 'wagon', 'rapidmarch','oxcart', 'porter') AND $2 IN ('downstream', 'fastdown') then (st_length(Geography(ST_Transform($3,4326)))::double precision) * .0000068
when $1 IN ('horse', 'carriage', 'privateroutine', 'privateaccelerated', 'fastcarriage', 'horserelay') AND $2 IN ('downstream', 'fastdown') then (st_length(Geography(ST_Transform($3,4326)))) * .00086

when $1 IN ('horse', 'carriage', 'privateroutine', 'privateaccelerated', 'fastcarriage', 'horserelay') AND $2 IN ('coastal', 'overseas', 'ferry' ,'slowover', 'slowcoast', 'dayslow', 'dayfast') then $4 * 25.2

when $1 IN ('donkey', 'foot', 'wagon', 'rapidmarch','oxcart', 'porter') AND $2 IN ('coastal', 'overseas', 'ferry' ,'slowover', 'slowcoast', 'dayslow', 'dayfast') then $4 * .1

else 99999
end
)
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;