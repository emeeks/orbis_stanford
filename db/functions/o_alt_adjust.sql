CREATE OR REPLACE FUNCTION o_alt_adjust(vehicle character varying, restricted character varying)
  RETURNS double precision AS
$BODY$
SELECT
(
CASE
when $1 = 'foot' AND $2 like '%cat1%' then .6
when $1 = 'foot' AND $2 like '%cat2%' then 1.2
when $1 = 'foot' AND $2 like '%cat3%' then 1.8
when $1 = 'oxcart' AND $2 like '%cat1%' then 1.5
when $1 = 'oxcart' AND $2 like '%cat2%' then 3
when $1 = 'oxcart' AND $2 like '%cat3%' then 4.5
when $1 = 'porter' AND $2 like '%cat1%' then .9
when $1 = 'porter' AND $2 like '%cat2%' then 1.8
when $1 = 'porter' AND $2 like '%cat3%' then 2.7
when $1 = 'horse' AND $2 like '%cat1%' then .3
when $1 = 'horse' AND $2 like '%cat2%' then .6
when $1 = 'horse' AND $2 like '%cat3%' then .9
when $1 = 'privateroutine' AND $2 like '%cat1%' then .5
when $1 = 'privateroutine' AND $2 like '%cat2%' then 1
when $1 = 'privateroutine' AND $2 like '%cat3%' then 1.5
when $1 = 'privateaccelerated' AND $2 like '%cat1%' then .2 
when $1 = 'privateaccelerated' AND $2 like '%cat2%' then .4
when $1 = 'privateaccelerated' AND $2 like '%cat3%' then .6
when $1 = 'horserelay' AND $2 like '%cat1%' then .5
when $1 = 'horserelay' AND $2 like '%cat2%' then 1
when $1 = 'horserelay' AND $2 like '%cat3%' then 1.5
when $1 = 'rapidmarch' AND $2 like '%cat1%' then .3
when $1 = 'rapidmarch' AND $2 like '%cat2%' then .6
when $1 = 'rapidmarch' AND $2 like '%cat3%' then .9
else 0
END
)::double precision
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;