﻿ -- Road length for new roads and edits to existing roads

SELECT sum(ST_Length(way))/1000 AS km_new_roads FROM planet_osm_line where highway in ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'residential', 'residential_link', 'service', 'tertiary', 'tertiary_link', 'road', 'track', 'unclassified', 'living_street') and osm_version = '1' and osm_id > 0;

SELECT sum(ST_Length(way))/1000 AS km_edits_to_existing_roads FROM planet_osm_line where highway in ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'residential', 'residential_link', 'service', 'tertiary', 'tertiary_link', 'road', 'track', 'unclassified', 'living_street') and osm_version > '1' and osm_id > 0; 

-- Road length for new roads with names and road length for edits to existing road segments with names

SELECT sum(ST_Length(way))/1000 AS km_new_named_roads FROM planet_osm_line where highway in ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'residential', 'residential_link', 'service', 'tertiary', 'tertiary_link', 'road', 'track', 'unclassified', 'living_street') and name is not null and osm_version = '1' and osm_id > 0;

SELECT sum(ST_Length(way))/1000 AS km_edits_to_existing_named_roads FROM planet_osm_line where highway in ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'residential', 'residential_link', 'service', 'tertiary', 'tertiary_link', 'road', 'track', 'unclassified', 'living_street') and name is not null and osm_version > '1' and osm_id > 0; 

-- Count of new road segments and edits to existing road segments

select osm_version, count(osm_version) as NewRoad_Segments from planet_osm_line where highway in ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'residential', 'residential_link', 'service', 'tertiary', 'tertiary_link', 'road', 'track', 'unclassified', 'living_street') and osm_version = '1' and osm_id > 0 group by osm_version;

select osm_version, count(osm_version) as ExistingRoad_Segments from planet_osm_line where highway in ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'residential', 'residential_link', 'service', 'tertiary', 'tertiary_link', 'road', 'track', 'unclassified', 'living_street') and osm_version > '1' and osm_id > 0 group by osm_version;

select count(*) from planet_osm_line where highway in ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'residential', 'residential_link', 'service', 'tertiary', 'tertiary_link', 'road', 'track', 'unclassified', 'living_street');

-- Road length of oneway roads, new and edits to existing oneway roads

SELECT sum(ST_Length(way))/1000 AS km_new_oneways FROM planet_osm_line where highway in ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'residential', 'residential_link', 'service', 'tertiary', 'tertiary_link', 'road', 'track', 'unclassified', 'living_street') and osm_version = '1' and (oneway = 'yes' or oneway = '-1') and osm_id > 0;

SELECT sum(ST_Length(way))/1000 AS km_edits_to_existing_oneways FROM planet_osm_line where highway in ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'residential', 'residential_link', 'service', 'tertiary', 'tertiary_link', 'road', 'track', 'unclassified', 'living_street') and osm_version > '1' and (oneway = 'yes' or oneway = '-1') and osm_id > 0; 

-- Road length edits by editor

select osm_user, sum(ST_Length(way))/1000 AS km_edits_per_editor FROM planet_osm_line where highway in ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'residential', 'residential_link', 'service', 'tertiary', 'tertiary_link', 'road', 'track', 'unclassified', 'living_street') and osm_id > 0 group by osm_user order by km_edits_per_editor desc;

-- Count of buildings  
select * from planet_osm_polygon where building is not null and building != 'no' and osm_id > 0;
SELECT COUNT (*) FROM planet_osm_polygon where building is not null and building != 'no' and osm_id > 0;

-- Count of buildings with addresses (1/2 done in QGIS until a query is figured out)

SELECT COUNT (*) FROM planet_osm_polygon where building is not null and building != 'no' and osm_id > 0 and ("addr:housenumber" is not null or "addr:housename" is not null or "addr:street" is not null);

-- must also count address points that intersect buildings and add to the result above
-- filter for points in QGIS:  "addr:housename"is not null or "addr:housenumber" is not null or "addr:street" is not null and "osm_id" > 0
-- filter for polygons in QGIS:  "building" is not null and "building" != 'no' and "osm_id" > 0

-- Total area of buildings

SELECT sum(ST_Area(way)/1000) as buildingAreaSqKm from planet_osm_polygon where building is not null and building != 'no' and osm_id > 0;

-- Count of building editors

select osm_user, count(osm_user) as Buildings_Edited from planet_osm_polygon where building is not null and building != 'no' and osm_id > 0 group by osm_user order by Buildings_Edited desc;

-- a few building/address attempts to ignore for now
-- select planet_osm_polygon.osm_id, count(planet_osm_point.way) as total
-- from planet_osm_polygon left join planet_osm_point
-- on st_contains(planet_osm_polygon.way,planet_osm_point.way)
-- group by planet_osm_polygon.osm_id;


-- select count(*) as pointsinpoly
-- from planet_osm_point, planet_osm_polygon
-- where st_contains(planet_osm_polygon.way,planet_osm_point.way)
-- group by planet_osm_polygon.osm_id;



-- Topology check between buildings and roads - should add group by to sum the lengths per building, but doing pivot tables afterwards works for now

-- Length of all road types intersected by buildings

select planet_osm_polygon.osm_id, (ST_LENGTH(ST_Intersection(planet_osm_polygon.way, planet_osm_line.way))/1000) 
from planet_osm_polygon, planet_osm_line 
where ST_Intersects(planet_osm_polygon.way, planet_osm_line.way) and planet_osm_polygon.building is not null and planet_osm_polygon.building != 'no' and planet_osm_polygon.osm_id > 0 and planet_osm_line.highway in ('motorway', 'motorway_link', 'trunk', 'trunk_link', 'primary', 'primary_link', 'secondary', 'secondary_link', 'residential', 'residential_link', 'service', 'tertiary', 'tertiary_link', 'road', 'track', 'unclassified', 'living_street') and planet_osm_line.osm_id > 0;

-- Length of primary road + links intersected by buildings

select planet_osm_polygon.osm_id, (ST_LENGTH(ST_Intersection(planet_osm_polygon.way, planet_osm_line.way))/1000) 
from planet_osm_polygon, planet_osm_line 
where ST_Intersects(planet_osm_polygon.way, planet_osm_line.way) and planet_osm_polygon.building is not null and planet_osm_polygon.building != 'no' and planet_osm_polygon.osm_id > 0 and planet_osm_line.highway in ('primary', 'primary_link') and planet_osm_line.osm_id > 0;

-- Length of secondary road + links intersected by buildings

select planet_osm_polygon.osm_id, (ST_LENGTH(ST_Intersection(planet_osm_polygon.way, planet_osm_line.way))/1000) 
from planet_osm_polygon, planet_osm_line 
where ST_Intersects(planet_osm_polygon.way, planet_osm_line.way) and planet_osm_polygon.building is not null and planet_osm_polygon.building != 'no' and planet_osm_polygon.osm_id > 0 and planet_osm_line.highway in ('secondary', 'secondary_link') and planet_osm_line.osm_id > 0;

-- Length of tertiary road + links intersected by buildings

select planet_osm_polygon.osm_id, (ST_LENGTH(ST_Intersection(planet_osm_polygon.way, planet_osm_line.way))/1000) 
from planet_osm_polygon, planet_osm_line 
where ST_Intersects(planet_osm_polygon.way, planet_osm_line.way) and planet_osm_polygon.building is not null and planet_osm_polygon.building != 'no' and planet_osm_polygon.osm_id > 0 and planet_osm_line.highway in ('tertiary', 'tertiary_link') and planet_osm_line.osm_id > 0;

-- Length of residential, and service roads intersected by buildings

select planet_osm_polygon.osm_id, (ST_LENGTH(ST_Intersection(planet_osm_polygon.way, planet_osm_line.way))/1000) 
from planet_osm_polygon, planet_osm_line 
where ST_Intersects(planet_osm_polygon.way, planet_osm_line.way) and planet_osm_polygon.building is not null and planet_osm_polygon.building != 'no' and planet_osm_polygon.osm_id > 0 and planet_osm_line.highway in ('residential', 'residential_link', 'service') and planet_osm_line.osm_id > 0;

-- Length of unclassified roads intersected by buildings

select planet_osm_polygon.osm_id, (ST_LENGTH(ST_Intersection(planet_osm_polygon.way, planet_osm_line.way))/1000) 
from planet_osm_polygon, planet_osm_line 
where ST_Intersects(planet_osm_polygon.way, planet_osm_line.way) and planet_osm_polygon.building is not null and planet_osm_polygon.building != 'no' and planet_osm_polygon.osm_id > 0 and planet_osm_line.highway in ('unclassified') and planet_osm_line.osm_id > 0;

-- Subset of POIs expected to be included in Mapzen tiles (written by Nathaniel, not me, hence the extra fancyness)

SELECT
    COALESCE("aerialway", "aeroway", "amenity", "barrier", "highway", "historic",
             "leisure", "lock", "man_made", "natural", "power", "railway", "shop",
             "tourism", "waterway") AS kind, count(*) as count 
FROM planet_osm_point
GROUP BY kind 
ORDER BY count DESC;


-- Count of editors

select osm_user, count(osm_user) as PointEdits from planet_osm_point group by osm_user order by PointEdits desc;
select osm_user, count(osm_user) as LineEdits from planet_osm_line group by osm_user order by LineEdits desc;
select osm_user, count(osm_user) as PolygonEdits from planet_osm_polygon group by osm_user order by PolygonEdits desc;

-- Count of all edits for POIs by editor

select osm_user, count(osm_user) as POIs from planet_osm_point where (aerialway is not null) or (aeroway is not null) or (amenity is not null) or (barrier is not null) or (highway is not null) or (historic is not null) or (leisure is not null) or (lock is not null) or (man_made is not null) or ("natural" is not null) or (power is not null) or (railway is not null) or (shop is not null) or (tourism is not null) or (waterway is not null) group by osm_user order by POIs desc;


-- Count of edits by editors for specific POI types (may not be mutually exclusive)
select osm_user, count(osm_user) as aerialwayEdits from planet_osm_point where aerialway is not null group by osm_user order by aerialwayEdits desc;
select osm_user, count(osm_user) as aerowayEdits from planet_osm_point where aeroway is not null group by osm_user order by aerowayEdits desc;
select osm_user, count(osm_user) as amenityEdits from planet_osm_point where amenity is not null group by osm_user order by amenityEdits desc;
select osm_user, count(osm_user) as barrierEdits from planet_osm_point where barrier is not null group by osm_user order by barrierEdits desc;
select osm_user, count(osm_user) as highwayEdits from planet_osm_point where highway is not null group by osm_user order by highwayEdits desc;
select osm_user, count(osm_user) as historicEdits from planet_osm_point where historic is not null group by osm_user order by historicEdits desc;
select osm_user, count(osm_user) as leisureEdits from planet_osm_point where leisure is not null group by osm_user order by leisureEdits desc;
select osm_user, count(osm_user) as lockEdits from planet_osm_point where "lock" is not null group by osm_user order by lockEdits desc;
select osm_user, count(osm_user) as man_madeEdits from planet_osm_point where man_made is not null group by osm_user order by man_madeEdits desc;
select osm_user, count(osm_user) as naturalEdits from planet_osm_point where "natural" is not null group by osm_user order by naturalEdits desc;
select osm_user, count(osm_user) as powerEdits from planet_osm_point where power is not null group by osm_user order by powerEdits desc;
select osm_user, count(osm_user) as railwayEdits from planet_osm_point where railway is not null group by osm_user order by railwayEdits desc;
select osm_user, count(osm_user) as shopEdits from planet_osm_point where shop is not null group by osm_user order by shopEdits desc;
select osm_user, count(osm_user) as tourismEdits from planet_osm_point where tourism is not null group by osm_user order by tourismEdits desc;
select osm_user, count(osm_user) as waterwayEdits from planet_osm_point where waterway is not null group by osm_user order by waterwayEdits desc;


-- Count of POIs by type

select 
(select count(*) as aerialway from planet_osm_point where aerialway is not null),
(select count(*) as aeroway from planet_osm_point where aeroway is not null),
(select count(*) as amenity from planet_osm_point where amenity is not null),
(select count(*) as barrier from planet_osm_point where barrier is not null),
(select count(*) as highway from planet_osm_point where highway is not null),
(select count(*) as historic from planet_osm_point where historic is not null),
(select count(*) as leisure from planet_osm_point where leisure is not null),
(select count(*) as "lock" from planet_osm_point where "lock" is not null),
(select count(*) as man_made from planet_osm_point where man_made is not null),
(select count(*) as "natural" from planet_osm_point where "natural" is not null),
(select count(*) as railway from planet_osm_point where railway is not null),
(select count(*) as highway from planet_osm_point where highway is not null),
(select count(*) as shop from planet_osm_point where shop is not null),
(select count(*) as tourism from planet_osm_point where tourism is not null),
(select count(*) as waterway from planet_osm_point where waterway is not null)

-- How are inland water features represented?

-- total area of polygonal inland water features
SELECT sum(ST_Area(way)/1000) as InlandWaterSqKm from planet_osm_polygon where waterway is not null and waterway != 'no' and osm_id > 0;

-- total length of linear inland water features
SELECT sum(ST_Length(way))/1000 AS km_InlandWater FROM planet_osm_line where waterway is not null and waterway != 'no' and osm_id > 0;

-- Can the inland water polygons be labeled?
SELECT sum(ST_Area(way)/1000) as InlandWaterSqKm_named from planet_osm_polygon where waterway is not null and name is not null and waterway != 'no' and osm_id > 0;

-- Can the inland water linear features by labeled?
SELECT sum(ST_Length(way))/1000 AS km_InlandWater_named FROM planet_osm_line where waterway is not null and name is not null and waterway != 'no' and osm_id > 0;