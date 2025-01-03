-- DDL
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    year_end_performance_scores INTEGER[] NOT NULL
);

INSERT INTO employees (name, salary, year_end_performance_scores) VALUES
('Alice Johnson', 75000.00, ARRAY[85, 90, 88, 92]),
('Bob Smith', 68000.00, ARRAY[78, 82, 80, 81]),
('Charlie Brown', 72000.00, ARRAY[91, 89, 94, 96]),
('Dana White', 64000.00, ARRAY[70, 75, 73, 72]),
('Eliot Green', 70000.00, ARRAY[88, 85, 90, 87]);

   
-- SQL
select sum(paid)
from (
	select
		salary * case
			when year_end_performance_scores[array_upper(year_end_performance_scores, 1)] > avg(year_end_performance_scores[array_upper(year_end_performance_scores, 1)]) over(partition by 'a') then 1.15
			else 1
			end as paid
	from employees
) sub;