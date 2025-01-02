-- DDL
DROP table if exists contact_list;
CREATE TABLE contact_list (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email_addresses TEXT[] NOT NULL
);

INSERT INTO contact_list (name, email_addresses) VALUES
('Santa Claus', 
 ARRAY['santa@northpole.com', 'kringle@workshop.net', 'claus@giftsrus.com']),
('Head Elf', 
 ARRAY['supervisor@workshop.net', 'elf1@northpole.com', 'toys@workshop.net']),
('Grinch', 
 ARRAY['grinch@mountcrumpit.com', 'meanie@whoville.org']),
('Rudolph', 
 ARRAY['red.nose@sleigh.com', 'rudolph@northpole.com', 'flying@reindeer.net']);

   
-- SQL
with cte as (
	select
		unnest(email_addresses) as email_address
	from contact_list cl
)
select
	substring(email_address, '[^@]+$') as "domain",
	count(*),
	array_agg(email_address)
from cte c
group by 1
order by 2 desc