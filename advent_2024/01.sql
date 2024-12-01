-- DDL
CREATE TABLE children (
    child_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT
);
CREATE TABLE wish_lists (
    list_id INT PRIMARY KEY,
    child_id INT,
    wishes JSON,
    submitted_date DATE
);
CREATE TABLE toy_catalogue (
    toy_id INT PRIMARY KEY,
    toy_name VARCHAR(100),
    category VARCHAR(50),
    difficulty_to_make INT
);

INSERT INTO children VALUES
(1, 'Tommy', 8),
(2, 'Sally', 7),
(3, 'Bobby', 9);

INSERT INTO wish_lists VALUES
(1, 1, '{"first_choice": "bike", "second_choice": "blocks", "colors": ["red", "blue"]}', '2024-11-01'),
(2, 2, '{"first_choice": "doll", "second_choice": "books", "colors": ["pink", "purple"]}', '2024-11-02'),
(3, 3, '{"first_choice": "blocks", "second_choice": "bike", "colors": ["green"]}', '2024-11-03');

INSERT INTO toy_catalogue VALUES
(1, 'bike', 'outdoor', 3),
(2, 'blocks', 'educational', 1),
(3, 'doll', 'indoor', 2),
(4, 'books', 'educational', 1);


--SQL
with  parsed as (
  select
      c."name",
      replace(cast(wishes::json->'first_choice' as varchar(1000)), '"', '') as primary_wish,
      replace(cast(wishes::json->'second_choice' as varchar(1000)), '"', '') as backup_wish,
      replace(substring(cast(wishes::json->'colors' as varchar(1000)) from '".+?"'), '"', '') as favorite_color,
      1 + length(cast(wishes::json->'colors' as varchar(1000))) - length(replace(cast(wishes::json->'colors' as varchar(100)), ',', '')) as color_count,
  submitted_date
  from wish_lists wl
    inner join children c
    	on wl.child_id = c.child_id
)
select
	p.name,
    p.primary_wish,
    p.backup_wish,
    p.favorite_color,
    p.color_count,
    case
        when tcp.difficulty_to_make = 1 then 'Simple Gift'
        when tcp.difficulty_to_make = 2 then 'Moderate Gift'
        when tcp.difficulty_to_make >= 3 then 'Complex Gift'
        end as gift_complexity,
    case
        when tcp.category = 'outdoor' then 'Outside Workshop'
        when tcp.category = 'educational' then 'Learning Workshop'
        else 'General Workshop'
      end as workshop_assignment
from parsed p
	inner join toy_catalogue tcp
    	on p.primary_wish = tcp.toy_name
	inner join toy_catalogue tcb
	on p.backup_wish = tcb.toy_name
order by 1
limit 5