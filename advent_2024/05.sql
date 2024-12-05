-- DDL
DROP TABLE IF EXISTS toy_production CASCADE;
CREATE TABLE toy_production (
    production_date DATE PRIMARY KEY,
    toys_produced INTEGER
);

INSERT INTO toy_production (production_date, toys_produced) VALUES
('2024-12-18', 500),
('2024-12-19', 550),
('2024-12-20', 525),
('2024-12-21', 600),
('2024-12-22', 580),
('2024-12-23', 620),
('2024-12-24', 610);

-- SQL
with cte as (
	select
		production_date,
		toys_produced,
		lead(toys_produced) over(partition by 'a' order by production_date desc) as previous_day_production
	from toy_production tp
)
select
	c.*,
	toys_produced - previous_day_production as production_change,
	cast((toys_produced - previous_day_production) as float) / previous_day_production * 100 as production_change_percentage
from cte c
order by 5 desc