-- DDL
DROP table if exists Workshops cascade;
CREATE TABLE Workshops (
    workshop_id INT PRIMARY KEY,
    workshop_name VARCHAR(100),
    timezone VARCHAR(50),
    business_start_time TIME,
    business_end_time TIME
);

INSERT INTO Workshops (workshop_id, workshop_name, timezone, business_start_time, business_end_time) VALUES
(1, 'North Pole HQ', 'UTC', '09:00', '17:00'),
(2, 'London Workshop', 'Europe/London', '09:00', '17:00'),
(3, 'New York Workshop', 'America/New_York', '09:00', '17:00');
   
-- SQL
-- NOTE: the accepted answer is 14:30:00, but the puzzle as presented is unsolveable
-- There are time zones where the working hours never overlap with NYC
-- The "best" answer with 66 of 67 workshops overlapping is 09:00:00
with dts as (
	select
		cast(concat('2024-12-', cast(n as int)) as date) as dt
	from generate_series(24, 26) n
)
, hrs as (
	select
		date '2024-12-25' + (n || ' hour')::interval as ts_start,
		date '2024-12-25' + (n+1 || ' hour')::interval as ts_end
	from generate_series(0, 23) n
	union
	select
		date '2024-12-25' + (n || ' hour')::interval + interval '30' minute as ts_start,
		date '2024-12-25' + (n+1 || ' hour')::interval + interval '30' minute as ts_end
	from generate_series(0, 23) n
)
, converted as (
	select
		w.*,
		dt + w.business_start_time - ptn.utc_offset as business_start_time_utc,
		dt + w.business_end_time - ptn.utc_offset as business_end_time_utc
	from pg_timezone_names ptn
		inner join (select * from workshops full join dts on 1=1) w
			on ptn."name" = w.timezone
)
select
	h.*,
	count(*)
from hrs h
	inner join converted c
		on h.ts_start >= c.business_start_time_utc
		and h.ts_end <= c.business_end_time_utc
group by 1,2
order by 3 desc, 1
limit 1