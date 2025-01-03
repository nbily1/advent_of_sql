-- DDL
DROP TABLE IF EXISTS sequence_table CASCADE;
CREATE TABLE sequence_table (
    id INT PRIMARY KEY
);

INSERT INTO sequence_table (id) VALUES 
    (1),
    (2),
    (3),
    (7),
    (8),
    (9),
    (11),
    (15),
    (16),
    (17),
    (22);

   
-- SQL
with cte as (
	select
		id,
		lag(id) over(order by id) as prev
	from sequence_table
)
select
	prev + 1 as gap_start,
	id - 1 as gap_end,
	array_to_string(array(select n from generate_series(prev + 1, id - 1) n), ',')
from cte c
where prev is not null
and id - prev > 1
order by 1