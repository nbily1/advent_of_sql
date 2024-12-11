-- DDL
DROP TABLE IF EXISTS TreeHarvests CASCADE;
CREATE TABLE TreeHarvests (
    field_name VARCHAR(50),
    harvest_year INT,
    season VARCHAR(6),
    trees_harvested INT
);

INSERT INTO TreeHarvests VALUES
('Rudolph Ridge', 2023, 'Spring', 150),
('Rudolph Ridge', 2023, 'Summer', 180),
('Rudolph Ridge', 2023, 'Fall', 220),
('Rudolph Ridge', 2023, 'Winter', 300),
('Dasher Dell', 2023, 'Spring', 165),
('Dasher Dell', 2023, 'Summer', 195),
('Dasher Dell', 2023, 'Fall', 210),
('Dasher Dell', 2023, 'Winter', 285);
   
-- SQL
select
	field_name,
	harvest_year,
	season,
	round(avg(trees_harvested)
		over(
			partition by field_name
			order by harvest_year * 10 + case season when 'Spring' then 1 when 'Summer' then 2 when 'Fall' then 3 when 'Winter' then 4 end
			range between 2 preceding and current row
		), 2) as three_season_moving_avg
from treeharvests t
order by 4 desc