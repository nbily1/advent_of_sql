-- DDL
DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    sale_date DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL
);

INSERT INTO sales (sale_date, amount) VALUES ('2024-01-10', 3500.25);
INSERT INTO sales (sale_date, amount) VALUES ('2023-01-15', 1500.50);
INSERT INTO sales (sale_date, amount) VALUES ('2023-04-20', 2000.00);
INSERT INTO sales (sale_date, amount) VALUES ('2023-07-12', 2500.75);
INSERT INTO sales (sale_date, amount) VALUES ('2023-10-25', 3000.00);

   
-- SQL
with cte as (
	select
		extract(year from sale_date) as "year",
		case
			when extract(month from sale_date) <= 3 then 1
			when extract(month from sale_date) <= 6 then 2
			when extract(month from sale_date) <= 9 then 3
			else 4
			end as "quarter",
		sum(amount) as total_sales
	from sales
	group by 1,2
)
select
	c.*,
	(total_sales - lag(total_sales) over(order by "year", "quarter")) / lag(total_sales) over(order by "year", "quarter") as growth_rate
from cte c
order by 4 desc